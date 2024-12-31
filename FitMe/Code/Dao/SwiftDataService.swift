import SwiftData
 
class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    @MainActor
    private init() {
        let schema = Schema([
            WorkoutDataModel.self
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
    
    func updateOrAddWorkout(_ workout: WorkoutDataModel) {
        modelContext.insert(workout)
        save()
    }
    
    func deleteWorkout(_ workout: WorkoutDataModel) {
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
