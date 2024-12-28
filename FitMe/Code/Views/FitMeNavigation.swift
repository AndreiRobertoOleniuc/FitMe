import SwiftUI
import SwiftData

#Preview {
    FitMeNavigation()
        .modelContainer(for: Item.self, inMemory: true)
}

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

struct ProfileView: View {
    var body: some View {
        VStack {
            Text("Profile Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "person.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}

struct CalendarView: View {
    var body: some View {
        VStack {
            Text("Calendar Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "calendar")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}
