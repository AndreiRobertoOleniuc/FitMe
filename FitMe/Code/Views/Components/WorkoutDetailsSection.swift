import SwiftUI

struct WorkoutDetailsSection: View {
    let workout: WorkoutDataModel
    
    var body: some View {
        Section(header: Text("Details")) {
            Text(workout.name)
                .font(.headline)
            Text(workout.workoutDescription)
                .font(.subheadline)
        }
    }
}
