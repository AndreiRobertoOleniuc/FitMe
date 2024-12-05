import SwiftUI
import SwiftData

struct FitMeNavigation: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        NavigationStack{
            TabView {
                HomeView()
                    .tabItem {
                        Label("Today", systemImage: "house")
                    }
                WorkoutView()
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell")
                    }
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
            }
        }
    }

}

#Preview {
    FitMeNavigation()
        .modelContainer(for: Item.self, inMemory: true)
}
