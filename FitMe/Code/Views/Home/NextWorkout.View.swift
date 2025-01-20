import SwiftUI

struct NextWorkoutView: View {
    let workout: Workout
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Next workout")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack {
                    VStack(alignment: .leading) {
                        Text(workout.name)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        Text("\(workout.exercises.count) exercises")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "calendar")
                }
            }
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}
