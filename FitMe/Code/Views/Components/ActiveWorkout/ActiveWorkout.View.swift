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

    var body: some View {
        Group {
            if let workout = viewModel.activeSession?.workout {
                VStack(alignment: .leading) {
                    ActiveWorkoutHeaderView(workoutName: workout.name)

                    ActiveWorkoutStatsView(
                        elapsedTime: viewModel.elapsedTime,
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
            viewModel.startTimer()
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .navigationBarBackButtonHidden(true)
        .interactiveDismissDisabled()
    }

    /// Ends the workout session.
    private func endWorkout() {
        viewModel.stopWorkoutSession()
        viewModel.stopTimer()
        dismiss()
    }
}
