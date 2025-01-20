import SwiftUI


struct ActiveWorkoutControlsView: View {
    let endWorkoutAction: () -> Void
    
    init(_ endWorkoutAction: @escaping () -> Void) {
        self.endWorkoutAction = endWorkoutAction
    }
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: endWorkoutAction) {
                Text("End Workout")
                    .frame(width: 120, height: 20)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            Spacer()
        }
        .padding(.bottom)
    }
}
