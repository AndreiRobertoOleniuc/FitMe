import SwiftUI
import Charts

struct CompactExerciseProgressChart: View {
    let exerciseName: String
    let category: String
    let performCount: Int
    let progressData: [(Date, Double)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Most Performed Exercise")
                    .font(.headline)
                Text("\(exerciseName) (\(category)) - \(performCount) times")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if progressData.isEmpty {
                Text("No progress data available")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                Chart(progressData, id: \.0) { date, weight in
                    LineMark(
                        x: .value("Date", date),
                        y: .value("Weight", weight)
                    )
                    PointMark(
                        x: .value("Date", date),
                        y: .value("Weight", weight)
                    )
                }
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: 3)) {
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .frame(height: 100)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(10)
    }
}
