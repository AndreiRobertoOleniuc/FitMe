import SwiftUI
import Charts

struct VolumeProgressChart: View {
    let data: [(Date, Int)]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Volume Over Time")
                .font(.headline)
                .padding()
            
            Chart(data, id: \.0) { item in
                LineMark(
                    x: .value("Date", item.0, unit: .day),
                    y: .value("Volume", item.1)
                )
                PointMark(
                    x: .value("Date", item.0, unit: .day),
                    y: .value("Volume", item.1)
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.month(.abbreviated).day())
                }
            }
            .chartYAxis {
                AxisMarks {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .frame(height: 300)
            .padding()
        }
    }
}
