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
                AxisMarks(values: .stride(by: .month, count: 1)) { value in // Use months for labels
                    AxisGridLine()
                    AxisValueLabel {
                        if let date = value.as(Date.self) {
                            Text(date, format: .dateTime.month(.abbreviated)) // Show abbreviated month (e.g., "Jan")
                                .font(.caption) // Adjust the font size
                        }
                    }
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
