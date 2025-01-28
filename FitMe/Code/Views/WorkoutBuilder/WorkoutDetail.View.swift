import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @ObservedObject var viewModel: WorkoutViewModel
    @State private var showingSearch = false
    @State private var selectedExercise: ExerciseAPI?
    @State private var startWorkout = false

    var body: some View {
        ZStack {
            VStack {
                List {
                    if let selectedWorkout = viewModel.getCurrentlySelectedWorkout() {
                        WorkoutDetailsSection(workout: selectedWorkout)
                        Section(header: Text("Exercises")) {
                            ForEach(selectedWorkout.exercises) { exercise in
                                NavigationLink(destination: ExerciseDetailView(workout: workout, exercise: exercise, viewModel: viewModel)) {
                                    WorkoutExerciseRow(
                                        exercise: exercise
                                    )
                                }
                            }
                            .onDelete { offsets in
                                viewModel.deleteExerciseFromWorkout(at: offsets, to: selectedWorkout)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Workout Details")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingSearch = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchExercise(viewModel: viewModel, workout: workout)
        }
        .onAppear {
            viewModel.selectWorkout(workout)
        }
    }
}
