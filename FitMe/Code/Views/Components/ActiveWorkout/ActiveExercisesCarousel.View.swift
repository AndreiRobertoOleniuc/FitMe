import SwiftUI

struct ActiveExercisesCarouselView: View {
    @ObservedObject var viewModel: ActiveWorkoutViewModel
    @State private var selectedTabIndex: Int = 0
    
    init(viewModel: ActiveWorkoutViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if let activeSession = viewModel.activeSession {
            // TabView for exercises
            TabView(selection: $selectedTabIndex) {
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
                Button(action: previousExercise) {
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
                
                Button(action: nextExercise) {
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
    
    private func previousExercise() {
        withAnimation(.easeInOut) {
            viewModel.nextExercise()
        }
    }
    
    private func nextExercise() {
        withAnimation(.easeInOut) {
            viewModel.previousExercise()
        }
    }
}
