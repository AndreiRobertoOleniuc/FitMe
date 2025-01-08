import Foundation
import SwiftData
 
@MainActor
class WorkoutViewModel: ObservableObject {
    private let model: ExerciseModel
    private let dataSource: SwiftDataService
    
    init(dataService: DataServiceProtocol, dataSource: SwiftDataService) {
        self.model = ExerciseModel(dataService: dataService)
        self.dataSource = dataSource
    }
    
    @Published var searchedExercises: [Suggestion] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var workouts: [Workout] = []
    
    func fetchExercises(query: String){
        isLoading = true
        Task {
            do {
                let fetchedSuggestions = try await model.searchExercise(query: query)
                searchedExercises = fetchedSuggestions.map { suggestion in
                    Suggestion(
                        value: suggestion.value,
                        data: ExerciseAPI(
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
    
    func addWorkout(workout: Workout){
        dataSource.updateOrAddWorkout(workout)
    }
 
    func deleteWorkout(_ workout: Workout) {
        dataSource.deleteWorkout(workout)
        fetchWorkouts()
    }
    
    func addExerciseToWorkout(_ exercise: ExerciseAPI, to workout: Workout) {
        workout.addExercise(convertToExercise(exercise))
        dataSource.updateOrAddWorkout(workout)
        fetchWorkouts()
    }
    
    func updateExerciseInWorkout(_ exercise: Exercise, to workout: Workout) {
        guard let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
        workout.exercises[index] = exercise
        dataSource.updateOrAddWorkout(workout)
    }
    
    
    func deleteExerciseFromWorkout(_ exercise: Exercise, to workout: Workout) {
        workout.exercises.removeAll { $0.id == exercise.id }
        dataSource.deleteExercise(exercise)
        dataSource.updateOrAddWorkout(workout)
    }
    
    private func convertToExercise(_ exercise: ExerciseAPI) -> Exercise {
        return Exercise(id: exercise.id, baseID: exercise.baseID, name: exercise.name, category: exercise.category, image: exercise.image, imageThumbnail: exercise.imageThumbnail)
    }
 
}
