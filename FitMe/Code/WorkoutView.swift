
import SwiftUI

struct WorkoutView: View {
    var body: some View {
        VStack {
            Text("Workout Screen")
                .font(.largeTitle)
                .padding()
            Image(systemName: "figure.strengthtraining.traditional")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
        }
    }
}
