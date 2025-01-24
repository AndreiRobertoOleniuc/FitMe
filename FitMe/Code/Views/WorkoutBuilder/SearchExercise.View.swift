import SwiftUI
import SwiftData
 
struct SearchExercise: View {
    @ObservedObject var viewModel: WorkoutViewModel
    let workout: Workout
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    List(viewModel.searchedExercises) { suggestion in 
                        Button(action: {
                            viewModel.addExerciseToWorkout(suggestion.data, to: workout)
                            dismiss()
                        }) {
                            HStack(spacing: 16) {
                                ImageView(
                                    imageURL: ImageView.getFullImageURL(suggestion.data.image),
                                    width: 120,
                                    height: 120,
                                    cornerRadius: 8
                                )
                                VStack(alignment: .leading) {
                                    Text(suggestion.value)
                                        .font(.headline)
                                    Text(suggestion.data.category)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationTitle("Add Exercise")
            .searchable(text: $searchText)
            .onChange(of: searchText) { _, newValue in
                Task {
                    try? await Task.sleep(for: .milliseconds(300))
                    if !newValue.isEmpty {
                        viewModel.fetchExercises(query: newValue)
                    }
                }
            }
        }
    }
}
 
