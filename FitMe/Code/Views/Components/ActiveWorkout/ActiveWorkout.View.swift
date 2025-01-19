import SwiftUI
import Combine
import SwiftData

#Preview {
    ModelContainerPreview {
        let viewModel = ActiveWorkoutViewModel(dataSource: SwiftDataService.shared)
        viewModel.fetchAllWorkoutSessions()
        return ActiveWorkoutView(viewModel: viewModel)
    } modelContainer: {
        let schema = Schema([Workout.self, Exercise.self, WorkoutSession.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return container
    }
}


struct ActiveWorkoutView: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?

    private var workout: Workout? {
        viewModel.activeSession?.workout
    }

    var body: some View {
        Group {
            if let workout = workout {
                VStack(alignment: .leading) {
                    ActiveWorkoutHeaderView(workoutName: workout.name)

                    ActiveWorkoutStatsView(
                        elapsedTime: elapsedTime,
                        totalVolume: viewModel.calculateTotalVolume(),
                        completedSets: viewModel.activeSession?.completedExecises.count ?? 0
                    )

                    if !workout.exercises.isEmpty {
                        ActiveExercisesCarouselView(
                            viewModel: viewModel
                        )
                    }

                    Spacer()

                    ActiveWorkoutControlsView {
                        endWorkout()
                    }
                }
                .padding(.horizontal)
                .frame(maxHeight: .infinity, alignment: .top)
            } else {
                Text("No active workout session")
            }
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled()
    }
    
    /// Starts the workout timer, updates every second.
    private func startTimer() {
        guard let startTime = viewModel.activeSession?.startTime else { return }
        timer?.invalidate()
        elapsedTime = Date().timeIntervalSince(startTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(startTime)
        }
    }

    /// Stops the workout timer.
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    /// Ends the workout session.
    private func endWorkout() {
        viewModel.stopWorkoutSession()
        stopTimer()
        dismiss()
    }
}
