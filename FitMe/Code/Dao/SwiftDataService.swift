import SwiftData
 
class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        let schema = Schema([
            Workout.self,
            Exercise.self,
            WorkoutSession.self,
            PerformedExercise.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
 
        self.modelContainer = try! ModelContainer(for: schema, configurations: [modelConfiguration])
        self.modelContext = modelContainer.mainContext
    }
    
    // Workout CRUD operations
    func fetchWorkouts() -> [Workout] {
        do {
            return try modelContext.fetch(FetchDescriptor<Workout>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateOrAddWorkout(_ workout: Workout) {
        modelContext.insert(workout)
        save()
    }
    
    func deleteWorkout(_ workout: Workout) {
        modelContext.delete(workout)
        save()
    }

    func deleteExercise(_ exercise: Exercise) {
        modelContext.delete(exercise)
        save()
    }
    
    func addWorkoutSession(_ workoutSession: WorkoutSession) {
        modelContext.insert(workoutSession)
        save()
    }
    
    func deleteWorkoutSession(_ workoutSession: WorkoutSession) {
        modelContext.delete(workoutSession)
        save()
    }

    func fetchWorkoutSessions() -> [WorkoutSession] {
        do {
            return try modelContext.fetch(FetchDescriptor<WorkoutSession>())
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    
    func save() {
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
