import Foundation
import SwiftData
 
@MainActor
class ExerciseViewModel: ObservableObject {
    private let model: ExerciseModel
    private let dataSource: SwiftDataService
    
    init(dataService: DataServiceProtocol, dataSource: SwiftDataService) {
        self.model = ExerciseModel(dataService: dataService)
        self.dataSource = dataSource
    }
    
    @Published var exercises: [Suggestion] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var workouts: [WorkoutDataModel] = []
    
    func fetchExercises(query: String){
        isLoading = true
        Task {
            do {
                let fetchedSuggestions = try await model.searchExercise(query: query)
                exercises = fetchedSuggestions.map { suggestion in
                    Suggestion(
                        value: suggestion.value,
                        data: Exercise(
                            id: suggestion.data.id,
                            baseID: suggestion.data.baseID,
                            name: suggestion.data.name,
                            category: suggestion.data.category,
                            image: suggestion.data.image.map { "https://wger.de\($0)" } ?? "",
                            imageThumbnail: suggestion.data.imageThumbnail.map { "https://wger.de\($0)" }
                        )
                    )
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func fetchWorkouts(){
        workouts = dataSource.fetchWorkouts()
    }
    
    func addWorkout(workout: WorkoutDataModel){
        dataSource.updateOrAddWorkout(workout)
    }
 
    func deleteWorkout(_ workout: WorkoutDataModel) {
        dataSource.deleteWorkout(workout)
        fetchWorkouts()
    }
    
    func addExerciseToWorkout(_ exercise: Exercise, to workout: WorkoutDataModel) {
        workout.addExercise(exercise)
        dataSource.updateOrAddWorkout(workout)
        fetchWorkouts()
    }
 
}
