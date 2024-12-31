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
                    NavigationLink(destination: WorkoutDetailView(workout: workout, viewModel: viewModelExercise)) {
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
