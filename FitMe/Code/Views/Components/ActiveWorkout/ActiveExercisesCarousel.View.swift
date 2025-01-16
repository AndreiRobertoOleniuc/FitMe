import SwiftUI

struct ActiveExercisesCarouselView: View {
    let exercises: [Exercise]
    @Binding var currentExerciseIndex: Int
    @Binding var completedExercises: Set<Int>
    
    /// Callback to toggle completion for a specific exercise index
    let onToggleCompletion: (Int) -> Void
    
    var body: some View {
        // TabView for exercises
        TabView(selection: $currentExerciseIndex) {
            ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                ActiveExerciseCard(
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
