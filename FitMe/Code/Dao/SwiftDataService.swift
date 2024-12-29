import SwiftData
 
class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        let schema = Schema([
            WorkoutDataModel.self,
            ExerciseDataModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
 
        self.modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        self.modelContext = modelContainer.mainContext
    }
    
    // Workout CRUD operations
    func fetchWorkouts() -> [WorkoutDataModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<WorkoutDataModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addWorkout(_ workout: WorkoutDataModel) {
        modelContext.insert(workout)
        save()
    }
    
    func deleteWorkout(_ workout: WorkoutDataModel) {
        modelContext.delete(workout)
        save()
    }
    
    // Exercise CRUD operations
    func fetchExercises() -> [ExerciseDataModel] {
        do {
            return try modelContext.fetch(FetchDescriptor<ExerciseDataModel>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func addExercise(_ exercise: ExerciseDataModel) {
        modelContext.insert(exercise)
        save()
    }
    
    func deleteExercise(_ exercise: ExerciseDataModel) {
        modelContext.delete(exercise)
        save()
    }
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}