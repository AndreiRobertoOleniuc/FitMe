import SwiftData
 
class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        let schema = Schema([
            Workout.self
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
    
    
    private func save() {
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
