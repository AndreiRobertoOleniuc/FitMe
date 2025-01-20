import SwiftUI
import Charts

struct CategoryWeightProgressView: View {
    @StateObject var viewModel: StatsViewModel
    
    /// Holds the currently selected category.
    @State private var selectedCategory: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // Category Picker
            VStack(alignment: .leading, spacing: 8) {
                Text("Select a Category")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Picker("Select a Category", selection: $selectedCategory) {
                    Text("None").tag("")
                    ForEach(viewModel.getAllCategories(), id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            }
            
            // If a category is chosen, show all exercise charts
            if !selectedCategory.isEmpty {
                ScrollView {
                    let exercisesInCategory = viewModel.getExercises(for: selectedCategory)
                    
                    // For each exercise in that category, show a chart
                    ForEach(exercisesInCategory, id: \.self) { exerciseName in
                        VStack(alignment: .leading) {
                            Text("Weight Progress - \(exerciseName)")
                                .font(.headline)
                                .padding(.top)
                            
                            let chartData = viewModel.getWeightProgressForExercise(named: exerciseName)
                            
                            if chartData.isEmpty {
                                // If there's no data for that exercise
                                Text("No data available for \(exerciseName)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.bottom)
                            } else {
                                Chart(chartData, id: \.0) { (date, weight) in
                                    LineMark(
                                        x: .value("Date", date),
                                        y: .value("Weight (kg)", weight)
                                    )
                                    PointMark(
                                        x: .value("Date", date),
                                        y: .value("Weight (kg)", weight)
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
                                .frame(height: 200)
                                .padding(.bottom)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .padding(.top)
        .onAppear {
            viewModel.fetchAllWorkoutSessions()
        }
    }
}

