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
            // Fixed Picker at top
            Picker("Stats Type", selection: $selectedTab) {
                Text("Volume").tag(0)
                Text("Frequency").tag(1)
                Text("Progress").tag(2)
            }
            .pickerStyle(.segmented)
            .padding()
            .background(Color(UIColor.systemBackground))
            
            // Scrollable content
            ScrollView {
                switch selectedTab {
                case 0:
                    VolumeProgressChart(data: viewModel.getVolumeProgress())
                case 1:
                    WorkoutFrequencyChart(data: viewModel.getWorkoutsPerWeek())
                case 2:
                    WeightProgressChart(viewModel: viewModel)
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
                    x: .value("Date", item.0),
                    y: .value("Volume", item.1)
                )
                PointMark(
                    x: .value("Date", item.0),
                    y: .value("Volume", item.1)
                )
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.month().day())
                }
            }
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


struct WeightProgressChart: View {
    @StateObject var viewModel: StatsViewModel
    @State private var selectedExercise: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Select an Exercise")
                Picker("Select Exercise", selection: $selectedExercise) {
                    ForEach(
                        Array(
                            Set(
                                viewModel.workoutSessions
                                    .flatMap { $0.performedExercises }
                                    .map { $0.name }
                            )
                        ), id: \.self
                    ) { exercise in
                        Text(exercise).tag(exercise)
                    }
                }
                .pickerStyle(.menu)
            }.padding(.bottom)
            
            if !selectedExercise.isEmpty {
                Text("Weight Progress - \(selectedExercise)")
                    .font(.headline)
                
                Chart(viewModel.getWeightProgressForExercise(named: selectedExercise), id: \.0) { item in
                    LineMark(
                        x: .value("Date", item.0),
                        y: .value("Weight (kg)", item.1)
                    )
                    PointMark(
                        x: .value("Date", item.0),
                        y: .value("Weight (kg)", item.1)
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
        }
        .padding()
    }
}
