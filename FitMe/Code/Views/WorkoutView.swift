import SwiftUI
import SwiftData

#Preview {
    WorkoutView()
        .modelContainer(for: [WorkoutDataModel.self, ExerciseDataModel.self], inMemory: true)
}

struct WorkoutView: View {
    @StateObject var viewModelExercise = ExerciseViewModel(dataService: RestService(baseURL: "https://wger.de/api/v2/exercise"))
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkoutDataModel.name) private var workouts: [WorkoutDataModel]

    var body: some View {
        NavigationStack {
            List(workouts) { workout in
                Text(workout.name)
            }
            .navigationTitle("My Workouts")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button(action: createNewWorkout) {
                        Text("Create New Workout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    func createNewWorkout() {
         let newWorkout = WorkoutDataModel(name: "New Workout", workoutDescription: "Description")
         modelContext.insert(newWorkout)
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
