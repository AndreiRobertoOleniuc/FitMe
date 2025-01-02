import SwiftUI

struct WorkoutExerciseRow: View {
    let exercise: Exercise
    
    var body: some View {
        HStack(spacing: 16) {
            ImageView(
                imageURL: ImageView.getFullImageURL(exercise.image),
                size: 60,
                cornerRadius: 8,
                systemName: ImageView.getSystemImageName(exercise.category)
            )
            VStack(alignment: .leading) {
                Text(exercise.name)
                    .font(.headline)
                Text("\(exercise.category) | \(exercise.sets)x\(exercise.reps) | \(exercise.rest)s rest")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
