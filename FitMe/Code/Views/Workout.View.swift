import SwiftUI
import SwiftData
 
struct WorkoutView: View {
    @StateObject private var viewModel = WorkoutViewModel(
        searchExerciseModel: SearchExercisService(dataService: RestService(baseURL: "https://wger.de/api/v2/exercise")),
        dataSource: SwiftDataService.shared
    )
 
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(workout.name)
                                .font(.headline)
                            Text(workout.workoutDescription)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteWorkout)
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingAddWorkout = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddWorkout) {
                NavigationView {
                    Form {
                        TextField("Workout Name", text: $viewModel.newWorkoutName)
                        TextField("Description", text: $viewModel.newWorkoutDescription)
                    }
                    .navigationTitle("New Workout")
                    .navigationBarItems(
                        leading: Button("Cancel") {
                            viewModel.showingAddWorkout = false
                        },
                        trailing: Button("Save") {
                            viewModel.addWorkout()
                            viewModel.showingAddWorkout = false
                        }
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchWorkouts()
        }
    }
}
