import SwiftUI

// MARK: - Exercise Card (unchanged except for any prop changes if needed)
struct ActiveExerciseCard: View {
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
