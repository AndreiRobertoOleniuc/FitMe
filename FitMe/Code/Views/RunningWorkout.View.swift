import SwiftUI

struct RunningWorkoutView: View {
    @StateObject private var viewModel = ActiveWorkoutViewModel(dataSource: .shared)
    @State private var selectedWorkout: Workout?

    var body: some View {
        Group {
            if let _ = viewModel.activeSession {
                ActiveWorkoutView(viewModel: viewModel)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("Start a Workout")
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        
                        if !viewModel.availabileWorkouts.isEmpty {
                            Text("Select a workout to start an active training session")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        LazyVStack(spacing: 20) {
                            ForEach(viewModel.availabileWorkouts.sorted(by: { $0.name < $1.name }), id: \.self) { workout in
                                Button(action: {
                                    viewModel.startWorkoutSession(workout)
                                }) {
                                    WorkoutCard(workout: workout)
                                }
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.horizontal)
                    .padding(.top)
                }
            }

        }
        .onAppear {
            viewModel.findAllPossibleWorkouts()
            viewModel.fetchAllWorkoutSessions()
        }
    }
}


struct WorkoutCard: View {
    let workout: Workout
    
    var totalSets: Int {
        workout.exercises.reduce(0) { $0 + $1.sets }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let firstExercise = workout.exercises.first {
                ImageView(
                    imageURL: ImageView.getFullImageURL(firstExercise.image),
                    width: 100,
                    height: 100,
                    cornerRadius: 12,
                    systemName: ImageView.getSystemImageName(firstExercise.category)
                )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(workout.name)
                    .bold()
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("\(workout.exercises.count) exercises")
                    .foregroundColor(.secondary)
                
                Text("\(totalSets) total sets")
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 120)
        .padding(16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
