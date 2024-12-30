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
 
struct WorkoutDetailView: View {
    let workout: WorkoutDataModel
    @ObservedObject var viewModel: ExerciseViewModel
    @State private var showingSearch = false
    @State private var isEditing = false
    
    var body: some View {
        List {
            Section(header: Text("Details")) {
                Text(workout.name)
                    .font(.headline)
                Text(workout.workoutDescription)
                    .font(.subheadline)
            }
            
            Section(header: Text("Exercises")) {
                ForEach(workout.exercises) { exercise in
                    HStack(spacing: 16) {
                        ExerciseImageView(
                            imageURL: ExerciseImageView.getFullImageURL(exercise.image),
                            size: 60,
                            cornerRadius: 8
                        )
                        VStack(alignment: .leading) {
                            Text(exercise.name)
                                .font(.headline)
                            Text(exercise.category)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if isEditing {
                            Button(action: {
                                // Delete exercise implementation
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Workout Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingSearch = true }) {
                    Image(systemName: "plus")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isEditing.toggle() }) {
                    Text(isEditing ? "Done" : "Edit")
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchExercise(viewModel: viewModel, workout: workout)
        }
    }
}

 
struct SearchExercise: View {
    @ObservedObject var viewModel: ExerciseViewModel
    let workout: WorkoutDataModel
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.exercises, id: \.data.id) { suggestion in
                        Button(action: {
                            viewModel.addExerciseToWorkout(suggestion.data, to: workout)
                            dismiss()
                        }) {
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
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                Task {
                    try? await Task.sleep(for: .milliseconds(300))
                    if !newValue.isEmpty {
                        viewModel.fetchExercises(query: newValue)
                    }
                }
            }
        }
    }
}
 
