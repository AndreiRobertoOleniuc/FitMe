import SwiftUI
import SwiftData

@main
struct FitMeApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            WorkoutDataModel.self,
            ExerciseDataModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            FitMeNavigation()
        }
        .modelContainer(sharedModelContainer)
    }
}
