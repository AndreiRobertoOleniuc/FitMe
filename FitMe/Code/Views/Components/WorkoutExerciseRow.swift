import SwiftUI

struct WorkoutExerciseRow: View {
    let exercise: Exercise
    let isEditing: Bool
    let onDelete: () -> Void
    let onEdit: () -> Void
    
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
                Text("\(exercise.category) | \(exercise.sets)x\(exercise.reps) | \(exercise.rest)s rest")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            if isEditing {
                HStack {
                    Button(action: onEdit) {
                        Image(systemName: "pencil")
                    }
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
