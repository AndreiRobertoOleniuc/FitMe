import SwiftUI

struct PastWorkoutSession: View {
    @StateObject private var viewModel = StatsViewModel(dataSource: .shared)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Past Workout Sessions")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            List {
                ForEach(viewModel.workoutSessions, id: \.id) { session in
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
                .onDelete(perform: viewModel.deleteWorkoutSession)
            }
            .onAppear {
                viewModel.fetchAllWorkoutSessions()
            }
        }
    }

}
