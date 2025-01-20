import SwiftUI
import SwiftData

#Preview {
    ModelContainerPreview {
        FitMeNavigation()
    } modelContainer: {
        let schema = Schema([Workout.self, Exercise.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return container
    }
}

struct FitMeNavigation: View {
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(Color(uiColor: .systemBackground))
                        .frame(height: UITabBarController().tabBar.frame.height)
                        .ignoresSafeArea()
                }
                TabView {
                    RunningWorkoutView()
                        .tabItem {
                            Label("Running", systemImage: "play.fill")
                        }
                        .tag(1)
                    WorkoutView()
                        .tabItem {
                            Label("Workouts", systemImage: "dumbbell")
                        }
                        .tag(2)
                    PastWorkoutSession()
                        .tabItem {
                            Label("Past", systemImage: "clock")
                        }
                        .tag(3)
                    StatsView()
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar.fill")
                        }
                        .tag(4)
                }
            
            }
        }
    }
}
