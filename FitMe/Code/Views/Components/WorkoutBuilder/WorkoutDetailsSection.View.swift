import SwiftUI

struct WorkoutDetailsSection: View {
    let workout: Workout
    
    var body: some View {
        Section(header: Text("Details")) {
            Text(workout.name)
                .font(.headline)
            Text(workout.workoutDescription)
                .font(.subheadline)
        }
    }
}
