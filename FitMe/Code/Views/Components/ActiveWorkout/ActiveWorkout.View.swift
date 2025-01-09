import SwiftUI
import Combine

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
                    WorkoutHeaderView(workoutName: workout.name)

                    // Stats
                    WorkoutStatsView(
                        elapsedTime: elapsedTime,
                        totalVolume: calculateTotalVolume(workout),
                        completedSets: completedExercises.count
                    )

                    // Exercise carousel
                    if !workout.exercises.isEmpty {
                        ExercisesCarouselView(
                            exercises: workout.exercises.sorted(by: { $0.order < $1.order }),
                            currentExerciseIndex: $currentExerciseIndex,
                            completedExercises: $completedExercises,
                            onToggleCompletion: toggleExerciseCompletion
                        )
                    }

                    Spacer()

                    // Controls (End Workout button)
                    WorkoutControlsView {
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
}

// MARK: - Subviews

struct WorkoutHeaderView: View {
    let workoutName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workoutName)
                .font(.title3)
                .bold()
                .padding([.bottom, .top], 5)
            
            Divider()
        }
    }
}

struct WorkoutStatsView: View {
    let elapsedTime: TimeInterval
    let totalVolume: Int
    let completedSets: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Duration")
                    .bold()
                Text(formatTime(elapsedTime))
                    .font(.body)
                    .foregroundColor(.blue)
                    .monospacedDigit()
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Volume")
                    .bold()
                Text("\(totalVolume) kg")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Sets")
                    .bold()
                Text("\(completedSets)")
            }
        }
        .padding(.vertical)
        
        Divider()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct ExercisesCarouselView: View {
    let exercises: [Exercise]
    @Binding var currentExerciseIndex: Int
    @Binding var completedExercises: Set<Int>
    
    /// Callback to toggle completion for a specific exercise index
    let onToggleCompletion: (Int) -> Void
    
    var body: some View {
        // TabView for exercises
        TabView(selection: $currentExerciseIndex) {
            ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                ExerciseCard(
                    exercise: exercise,
                    isCompleted: completedExercises.contains(index),
                    onComplete: {
                        onToggleCompletion(index)
                    }
                )
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 400)
        
        // Navigation buttons
        HStack {
            Button(action: previousExercise) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .padding()
            }
            .disabled(currentExerciseIndex == 0)
            
            Spacer()
            
            Button(action: {
                onToggleCompletion(currentExerciseIndex)
            }) {
                Image(systemName: completedExercises.contains(currentExerciseIndex)
                      ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.title2)
                    .padding()
            }
            
            Spacer()
            
            Button(action: nextExercise) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .padding()
            }
            .disabled(currentExerciseIndex == exercises.count - 1)
        }
        .padding()
    }
    
    // MARK: - Carousel Navigation
    private func previousExercise() {
        if currentExerciseIndex > 0 {
            withAnimation(.easeInOut) {
                currentExerciseIndex -= 1
            }
        }
    }
    
    private func nextExercise() {
        if currentExerciseIndex < exercises.count - 1 {
            withAnimation(.easeInOut) {
                currentExerciseIndex += 1
            }
        }
    }
}

struct WorkoutControlsView: View {
    let endWorkoutAction: () -> Void
    
    init(_ endWorkoutAction: @escaping () -> Void) {
        self.endWorkoutAction = endWorkoutAction
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: endWorkoutAction) {
                Text("End Workout")
                    .frame(width: 120, height: 20)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            Spacer()
        }
        .padding(.bottom)
    }
}

// MARK: - Exercise Card (unchanged except for any prop changes if needed)
struct ExerciseCard: View {
    let exercise: Exercise
    let isCompleted: Bool
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ImageView(
                imageURL: ImageView.getFullImageURL(exercise.image),
                width: 150,
                height: 150,
                cornerRadius: 10,
                systemName: ImageView.getSystemImageName(exercise.category)
            )
            
            Text(exercise.name)
                .font(.title2)
                .bold()
            
            VStack(spacing: 8) {
                DetailRow(title: "Sets", value: "\(exercise.sets)")
                DetailRow(title: "Reps", value: "\(exercise.reps)")
                DetailRow(title: "Weight", value: "\(exercise.weight) kg")
                DetailRow(title: "Rest", value: "\(exercise.rest) sec")
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(isCompleted ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCompleted ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// MARK: - Private extension / helper methods for ActiveWorkoutView
extension ActiveWorkoutView {
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
