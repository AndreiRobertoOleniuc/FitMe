import SwiftUI

struct WorkoutExerciseRow: View {
    let exercise: Exercise
    let isEditing: Bool
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ExerciseImageView(
                imageURL: ExerciseImageView.getFullImageURL(exercise.image),
                size: 60,
                cornerRadius: 8
            )
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text(exercise.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if isEditing {
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

