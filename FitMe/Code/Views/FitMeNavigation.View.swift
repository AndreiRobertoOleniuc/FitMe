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
    @State private var selectedTab = 1
    
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
                TabView(selection: $selectedTab) {
                    HomeScreen(selectedTab: $selectedTab)
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(1)
                    RunningWorkoutView()
                        .tabItem {
                            Label("Running", systemImage: "play.fill")
                        }
                        .tag(2)
                    WorkoutView()
                        .tabItem {
                            Label("Workouts", systemImage: "dumbbell")
                        }
                        .tag(3)
                    PastWorkoutSession()
                        .tabItem {
                            Label("Past", systemImage: "clock")
                        }
                        .tag(4)
                    StatsView()
                        .tabItem {
                            Label("Stats", systemImage: "chart.bar.fill")
                        }
                        .tag(5)
                }
            }
        }
    }
}