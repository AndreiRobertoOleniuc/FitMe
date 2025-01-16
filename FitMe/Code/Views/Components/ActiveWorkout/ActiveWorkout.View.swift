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
    
        //This View will show data if a Workout is currently active
        return container
    }
}


struct ActiveWorkoutView: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - State
    @State private var currentExerciseIndex = 0
    @State private var completedExercises: Set<Int> = []
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?

    private var workout: Workout? {
        viewModel.activeSession?.workout
    }

    // MARK: - Body
    var body: some View {
        Group {
            if let workout = workout {
                VStack(alignment: .leading) {
                    // Header
                    ActiveWorkoutHeaderView(workoutName: workout.name)

                    // Stats
                    ActiveWorkoutStatsView(
                        elapsedTime: elapsedTime,
                        totalVolume: calculateTotalVolume(workout),
                        completedSets: completedExercises.count
                    )

                    // Exercise carousel
                    if !workout.exercises.isEmpty {
                        ActiveExercisesCarouselView(
                            exercises: workout.exercises.sorted(by: { $0.order < $1.order }),
                            currentExerciseIndex: $currentExerciseIndex,
                            completedExercises: $completedExercises,
                            onToggleCompletion: toggleExerciseCompletion
                        )
                    }

                    Spacer()

                    // Controls (End Workout button)
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

    /// Calculates total volume based on all completed exercises.
    private func calculateTotalVolume(_ workout: Workout) -> Int {
        completedExercises.reduce(0) { total, index in
            total + Int(workout.exercises[index].weight *
                        Double(workout.exercises[index].sets *
                               workout.exercises[index].reps))
        }
    }

    /// Toggles exercise completion and moves to the next exercise if completed.
    private func toggleExerciseCompletion(_ index: Int) {
        if completedExercises.contains(index) {
            completedExercises.remove(index)
        } else {
            completedExercises.insert(index)
            // Automatically go to the next exercise
            if let workout = workout, index < workout.exercises.count - 1 {
                withAnimation(.easeInOut) {
                    currentExerciseIndex += 1
                }
            }
        }
    }

    /// Ends the workout session.
    private func endWorkout() {
        viewModel.stopWorkoutSession()
        stopTimer()
        dismiss()
    }
}
