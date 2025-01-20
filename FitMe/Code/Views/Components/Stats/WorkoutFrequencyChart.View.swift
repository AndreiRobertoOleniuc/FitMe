import SwiftUI
import Charts


struct WorkoutFrequencyChart: View {
    let data: [Date: Int]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Workout Frequency by Week")
                .font(.headline)
                .padding(.leading)
            
            Chart(data.sorted(by: { $0.key < $1.key }), id: \.key) { item in
                BarMark(
                    x: .value("Week", item.key, unit: .weekOfYear),
                    y: .value("Workouts", item.value)
                )
            }
            .chartXAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
        }
        .padding()
    }
}
