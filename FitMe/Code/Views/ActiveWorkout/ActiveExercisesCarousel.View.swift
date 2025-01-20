import SwiftUI

struct ActiveExercisesCarouselView: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    
    init(viewModel: ActiveWorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    private var currentExerciseBinding: Binding<Int> {
        Binding(
            get: { viewModel.activeSession?.currentExercise ?? 0 },
            set: { newValue in
                viewModel.setCurrentExercise(newValue)
            }
        )
    }
    
    var body: some View {
        if let activeSession = viewModel.activeSession {
            // TabView for exercises
            TabView(selection: currentExerciseBinding) {
                ForEach(Array(activeSession.workout.exercises.enumerated()), id: \.element.id) { index, exercise in
                    ActiveExerciseCard(
                        exercise: exercise,
                        isCompleted: activeSession.completedExecises.contains(index),
                        onComplete: {
                            viewModel.toggleCompletedExercise(index)
                        }
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 400)
            
            // Navigation buttons
            HStack {
                Button(action: viewModel.previousExercise) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                }
                .disabled(activeSession.currentExercise == 0)
                
                Spacer()
                
                Button(action: {
                    viewModel.toggleCompletedExercise(activeSession.currentExercise)
                }) {
                    Image(systemName: activeSession.completedExecises.contains(activeSession.currentExercise)
                              ? "checkmark.circle.fill" : "checkmark.circle")
                        .font(.title2)
                        .padding()
                }
                    
                Spacer()
                
                Button(action: viewModel.nextExercise) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                        .padding()
                }
                .disabled(activeSession.currentExercise == activeSession.workout.exercises.count - 1)
            }
            .padding()
        } else {
            Text("No active session")
        }
    }
}
