import SwiftUI

struct ActiveWorkoutStatsView: View {
    let elapsedTime: TimeInterval
    let totalVolume: Int
    let completedSets: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Duration")
                    .bold()
                Text(formatTime(elapsedTime))
                    .font(.body)
                    .foregroundColor(.blue)
                    .monospacedDigit()
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Volume")
                    .bold()
                Text("\(totalVolume) kg")
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text("Sets")
                    .bold()
                Text("\(completedSets)")
            }
        }
        .padding(.vertical)
        
        Divider()
    }
    
    private func formatTime(_ time: TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = (Int(time) % 3600) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}
