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
                    .tag(1)
                WorkoutView()
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell")
                    }
                    .tag(2)
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(3)
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(4)
            }
        }
    }

}

#Preview {
    FitMeNavigation()
        .modelContainer(for: Item.self, inMemory: true)
}
