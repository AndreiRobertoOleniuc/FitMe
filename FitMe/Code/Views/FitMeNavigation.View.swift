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
        NavigationStack{
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
            }
        }
    }

}

struct PastWorkoutSession: View {
    @StateObject private var viewModel = StatsViewModel(dataSource: .shared)
    
    var body: some View {
        List {
            ForEach(viewModel.workoutSessions.filter { !$0.isActive }, id: \.id) { session in
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.workout.name)
                        .font(.headline)
                    if let startTime = session.startTime {
                        Text(startTime, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "dumbbell.fill")
                        Text("Total Volume: \(viewModel.calculateTotalVolumeForSession(session)) kg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteSession)
        }
        .onAppear {
            viewModel.fetchAllWorkoutSessions()
        }
    }
    
    private func deleteSession(at offsets: IndexSet) {
        let filteredSessions = viewModel.workoutSessions.filter { !$0.isActive }
        offsets.forEach { index in
            let session = filteredSessions[index]
            viewModel.deleteWorkoutSession(session)
        }
    }
}
