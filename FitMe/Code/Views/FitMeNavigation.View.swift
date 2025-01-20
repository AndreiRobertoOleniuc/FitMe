import SwiftUI
import SwiftData
import Charts

#Preview {
    ModelContainerPreview {
        FitMeNavigation()
    } modelContainer: {
        let schema = Schema([Workout.self, Exercise.self])
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return container
    }
}

struct FitMeNavigation: View {
    var body: some View {
        NavigationStack{
            TabView {
                RunningWorkoutView()
                    .tabItem {
                        Label("Running", systemImage: "play.fill")
                    }
                    .tag(1)
                WorkoutView()
                    .tabItem {
                        Label("Workouts", systemImage: "dumbbell")
                    }
                    .tag(2)
                PastWorkoutSession()
                    .tabItem {
                        Label("Past", systemImage: "clock")
                    }
                    .tag(3)
                StatsView()
                    .tabItem {
                        Label("Stats", systemImage: "chart.bar.fill")
                    }
                    .tag(4)
            }
        }
    }

}

struct PastWorkoutSession: View {
    @StateObject private var viewModel = StatsViewModel(dataSource: .shared)
    
    var body: some View {
        List {
            ForEach(viewModel.workoutSessions.filter { !$0.isActive }, id: \.id) { session in
                VStack(alignment: .leading, spacing: 4) {
                    Text(session.workout.name)
                        .font(.headline)
                    if let startTime = session.startTime {
                        Text(startTime, style: .date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "dumbbell.fill")
                        Text("Total Volume: \(viewModel.calculateTotalVolumeForSession(session)) kg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .onDelete(perform: deleteSession)
        }
        .onAppear {
            viewModel.fetchAllWorkoutSessions()
        }
    }
    
    private func deleteSession(at offsets: IndexSet) {
        let filteredSessions = viewModel.workoutSessions.filter { !$0.isActive }
        offsets.forEach { index in
            let session = filteredSessions[index]
            viewModel.deleteWorkoutSession(session)
        }
    }
}

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel(dataSource: .shared)
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header "Progression" aligned to leading
            HStack {
                Text("Progression")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
            }
            
            // Segmented Picker at the top
            Picker("Stats Type", selection: $selectedTab) {
                Text("Volume").tag(0)
                Text("Frequency").tag(1)
                Text("By Category").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .background(Color(UIColor.systemBackground))
            
            // Scrollable content
            ScrollView {
                switch selectedTab {
                case 0:
                    VolumeProgressChart(data: viewModel.getVolumeProgress())
                case 1:
                    WorkoutFrequencyChart(data: viewModel.getWorkoutsPerWeek())
                case 2:
                    CategoryWeightProgressView(viewModel: viewModel)
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchAllWorkoutSessions()
        }
    }
}



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
