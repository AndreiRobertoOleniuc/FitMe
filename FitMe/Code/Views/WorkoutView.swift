import SwiftUI
import SwiftData
 
struct WorkoutView: View {
    @StateObject private var viewModelExercise = ExerciseViewModel(dataService: RestService(baseURL: "https://wger.de/api/v2/exercise"), dataSource: .shared)
 
    @State private var showingAddWorkout = false
    @State private var newWorkoutName = ""
    @State private var newWorkoutDescription = ""
 
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModelExercise.workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                            Text(workout.workoutDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteWorkout)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddWorkout) {
                NavigationView {
                    Form {
                        TextField("Workout Name", text: $newWorkoutName)
                        TextField("Description", text: $newWorkoutDescription)
                    }
                    .navigationTitle("New Workout")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            showingAddWorkout = false
                        },
                        trailing: Button("Save") {
                            addWorkout()
                            showingAddWorkout = false
                        }
                    )
                }
            }
        }
        .onAppear {
            viewModelExercise.fetchWorkouts()
        }
    }
    
    private func addWorkout() {
        let workout = WorkoutDataModel(
            name: newWorkoutName,
            workoutDescription: newWorkoutDescription
        )
        viewModelExercise.addWorkout(workout: workout)
        viewModelExercise.fetchWorkouts()
        newWorkoutName = ""
        newWorkoutDescription = ""
    }
    
    private func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let workout = viewModelExercise.workouts[index]
            viewModelExercise.deleteWorkout(workout)
        }
        viewModelExercise.fetchWorkouts()
    }
 
}
 
struct WorkoutDetailView: View {
    let workout: WorkoutDataModel
    
    var body: some View {
        VStack {
            Text(workout.name)
                .font(.title)
            Text(workout.workoutDescription)
                .padding()
            
            List(workout.exercises) { exercise in
                Text(exercise.name)
            }
        }
    }
}
 
struct SearchExercise: View {
    @ObservedObject var viewModelExercise: ExerciseViewModel
    @State private var searchText = ""
    
    var body: some View{
        NavigationView {
            VStack {
                if viewModelExercise.isLoading {
                    ProgressView()
                } else if let error = viewModelExercise.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else {
                    List(viewModelExercise.exercises, id: \.data.id) { suggestion in
                        HStack(spacing: 16) {
                            ExerciseImageView(
                                imageURL: ExerciseImageView.getFullImageURL(suggestion.data.image),
                                size: 60,
                                cornerRadius: 8
                            )
                            VStack(alignment: .leading) {
                                Text(suggestion.value)
                                    .font(.headline)
                                Text(suggestion.data.category)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Exercises")
            .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
                Task {
                    try? await Task.sleep(for: .milliseconds(300))
                    if !Task.isCancelled && !newValue.isEmpty{
                        viewModelExercise.fetchExercises(query: newValue)
                    }
                }
            }
        }
    }
}
 