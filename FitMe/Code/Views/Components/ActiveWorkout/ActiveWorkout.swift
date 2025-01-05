import SwiftUI
import Combine

struct ActiveWorkout: View {
    @ObservedObject var viewModel: WorkoutViewModel
    let workout: Workout
    @State private var currentExerciseIndex = 0
    @State private var completedExercises: Set<Int> = []
    
    // Timer states
    @State private var secondsElapsed = 0
    @State private var timerIsActive = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Workout header
            Text(workout.name)
                .font(.title3)
                .bold()
                .padding([.bottom, .top], 5)
            
            Divider()
            
            // Stats section
            HStack {
                TimerView(
                    secondsElapsed: $secondsElapsed,
                    timerIsActive: $timerIsActive,
                    timer: timer
                )
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Volume")
                        .bold()
                    Text("\(calculateTotalVolume()) kg")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Sets")
                        .bold()
                    Text("\(completedExercises.count)")
                }
            }
            .padding(.vertical)
            
            Divider()
            
            // Exercise carousel
            if !workout.exercises.isEmpty {
                TabView(selection: $currentExerciseIndex) {
                    ForEach(Array(workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                        ExerciseCard(
                            exercise: exercise,
                            isCompleted: completedExercises.contains(index),
                            onComplete: { toggleExerciseCompletion(index) }
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
                            .padding()
                    }
                    .disabled(currentExerciseIndex == 0)
                    
                    Spacer()
                    
                    Button(action: { toggleExerciseCompletion(currentExerciseIndex) }) {
                        Image(systemName: completedExercises.contains(currentExerciseIndex) ? "checkmark.circle.fill" : "checkmark.circle")
                            .padding()
                    }
                    
                    Spacer()
                    
                    Button(action: nextExercise) {
                        Image(systemName: "chevron.right")
                            .padding()
                    }
                    .disabled(currentExerciseIndex == workout.exercises.count - 1)
                }
                .padding()
            }
            
            Spacer()
            
            // Timer controls
            HStack {
                Button(action: toggleTimer) {
                    Text(timerIsActive ? "Pause" : "Start")
                        .padding()
                        .background(timerIsActive ? Color.blue : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
                
                Button(action: endWorkout) {
                    Text("End")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(5)
                }
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private func calculateTotalVolume() -> Int {
        completedExercises.reduce(0) { total, index in
            total + Int(workout.exercises[index].weight * Double(workout.exercises[index].sets * workout.exercises[index].reps))
        }
    }
    
    private func toggleTimer() {
        if timerIsActive {
            timer.upstream.connect().cancel()
        } else {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
        timerIsActive.toggle()
    }
    
    private func endWorkout() {
        timer.upstream.connect().cancel()
        timerIsActive = false
        secondsElapsed = 0
    }
    
    private func previousExercise() {
        if currentExerciseIndex > 0 {
            currentExerciseIndex -= 1
        }
    }
    
    private func nextExercise() {
        if currentExerciseIndex < workout.exercises.count - 1 {
            currentExerciseIndex += 1
        }
    }
    
    private func toggleExerciseCompletion(_ index: Int) {
        if completedExercises.contains(index) {
            completedExercises.remove(index)
        } else {
            completedExercises.insert(index)
        }
    }
}

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


struct TimerView: View {
    @Binding var secondsElapsed: Int
    @Binding var timerIsActive: Bool
    let timer: Publishers.Autoconnect<Timer.TimerPublisher>
    
    private var formattedTime: String {
        let hours = secondsElapsed / 3600
        let minutes = (secondsElapsed % 3600) / 60
        let seconds = secondsElapsed % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Duration")
                .bold()
            Text(formattedTime)
                .font(.body)
                .foregroundColor(Color.blue)
                .monospacedDigit()
        }
        .onReceive(timer) { _ in
            if timerIsActive {
                secondsElapsed += 1
            }
        }
    }
}
