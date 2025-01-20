import SwiftUI

struct StatsView: View {
    @StateObject private var viewModel = StatsViewModel(dataSource: .shared)
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header "Progression" aligned to leading
            HStack {
                Text("Progression")
                    .font(.title)
                    .bold()
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


