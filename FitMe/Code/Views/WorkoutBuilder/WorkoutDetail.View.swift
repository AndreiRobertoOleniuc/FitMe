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
                    WorkoutDetailsSection(workout: workout)
                    Section(header: Text("Exercises")) {
                        ForEach(workout.exercises.sorted(by: { $0.order < $1.order })) { exercise in
                            NavigationLink(destination: ExerciseDetailView(workout: workout, exercise: exercise, viewModel: viewModel)) {
                                WorkoutExerciseRow(
                                    exercise: exercise
                                )
                            }
                        }
                        .onDelete(perform: deleteExercise)
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
    }
    
    private func deleteExercise(at offsets: IndexSet) {
        offsets.forEach { index in
            let exercise = workout.exercises[index]
            viewModel.deleteExerciseFromWorkout(exercise, to: workout)
        }
    }
}


struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .bold()
        }
        .padding(.horizontal)
    }
}
