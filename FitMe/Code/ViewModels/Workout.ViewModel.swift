import Foundation
import SwiftData
 
@MainActor
class WorkoutViewModel: ObservableObject {
    private let searchExerciseModel: SearchExerciseModel
    private let dataSource: SwiftDataService
    
    init(dataService: DataServiceProtocol, dataSource: SwiftDataService) {
        self.searchExerciseModel = SearchExerciseModel(dataService: dataService)
        self.dataSource = dataSource
    }
        
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    //Workouts
    @Published var workouts: [Workout] = []
    
    //Adding New Workout
    @Published var showingAddWorkout = false
    @Published var newWorkoutName = ""
    @Published var newWorkoutDescription = ""
    
    //SearchedExercises
    @Published var searchedExercises: [Suggestion] = []

    //For the Detail Screen
    @Published var selectedWorkout: UUID?

    
    func searchExercise(query: String){
        isLoading = true
        Task {
            do {
                let fetchedSuggestions = try await searchExerciseModel.searchExercise(query: query)
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
    
    ///Workouts
    func fetchWorkouts(){
        workouts = dataSource.fetchWorkouts().sorted(by: { $0.name < $1.name })
        workouts.forEach { workout in
            workout.exercises = workout.exercises.sorted(by: { $0.order < $1.order })
        }
    }
    
    func addWorkout() {
        let workout = Workout(
            name: newWorkoutName,
            workoutDescription: newWorkoutDescription
        )
        dataSource.updateOrAddWorkout(workout)
        resetNewWorkoutForm()
        fetchWorkouts()
    }
    
    func deleteWorkout(at offsets: IndexSet) {
        offsets.forEach { index in
            let workout = workouts[index]
            dataSource.deleteWorkout(workout)
        }
        fetchWorkouts()
    }
    
    func getCurrentlySelectedWorkout() -> Workout? {
        return workouts.first(where: { $0.id == selectedWorkout })
    }
    
    ///Exercise -> Workout
    func addExerciseToWorkout(_ exercise: ExerciseAPI, to workout: Workout) {
        workout.addExercise(convertToExercise(exercise))
        dataSource.updateOrAddWorkout(workout)
        fetchWorkouts()
    }
    
    func updateExerciseInWorkout(_ exercise: Exercise, to workout: Workout) {
        guard let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) else { return }
        workout.exercises[index] = exercise
        dataSource.updateOrAddWorkout(workout)
        fetchWorkouts()
    }
    
    func deleteExerciseFromWorkout(at offsets: IndexSet, to workout: Workout) {
        offsets.forEach { index in
            let exercise = workout.exercises[index]
            workout.exercises.remove(at: index)
            dataSource.deleteExercise(exercise)
            dataSource.updateOrAddWorkout(workout)
            fetchWorkouts()
        }
    }
    
    ///Helpers
    func selectWorkout(_ workout: Workout) {
        selectedWorkout = workout.id
    }
    
    private func convertToExercise(_ exercise: ExerciseAPI) -> Exercise {
        return Exercise(id: exercise.id, baseID: exercise.baseID, name: exercise.name, category: exercise.category, image: exercise.image, imageThumbnail: exercise.imageThumbnail)
    }
    
    private func resetNewWorkoutForm() {
        newWorkoutName = ""
        newWorkoutDescription = ""
    }
 
 
}
