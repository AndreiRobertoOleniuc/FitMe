import SwiftUI

struct ActiveWorkoutHeaderView: View {
    let workoutName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workoutName)
                .font(.title3)
                .bold()
                .padding([.bottom, .top], 5)
            
            Divider()
        }
    }
}

