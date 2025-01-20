import SwiftUI

struct PastWorkoutSession: View {
    @StateObject private var viewModel = StatsViewModel(dataSource: .shared)
    
    var body: some View {
        VStack(spacing: 0) {
            // Large title header at the top, aligned to leading
            HStack {
                Text("Past Workout Sessions")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            // The List follows below the header
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
    }
    
    private func deleteSession(at offsets: IndexSet) {
        let filteredSessions = viewModel.workoutSessions.filter { !$0.isActive }
        offsets.forEach { index in
            let session = filteredSessions[index]
            viewModel.deleteWorkoutSession(session)
        }
    }
}
