import SwiftUI

struct WorkoutView: View {
    @StateObject var viewModelExercise = ExerciseViewModel(dataService: RestService(baseURL: "https://wger.de/api/v2/exercise"))
    @State private var searchText = ""
    
    
    var body: some View {
            NavigationView {
                VStack {
                    if viewModelExercise.isLoading {
                        ProgressView()
                    } else if let error = viewModelExercise.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        List(viewModelExercise.exercises, id: \.data.id) { suggestion in
                            HStack(spacing: 16) {
                                ExerciseImageView(
                                    imageURL: ExerciseImageView.getFullImageURL(suggestion.data.image),
                                    size: 60,
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
                    }
                }
                .navigationTitle("Exercises")
                .searchable(text: $searchText)
                .onChange(of: searchText) { oldValue, newValue in
                    Task {
                        try? await Task.sleep(for: .milliseconds(300))
                        if !Task.isCancelled {
                            viewModelExercise.fetchExercises(query: newValue.isEmpty ? "chest" : newValue)
                        }
                    }
                }
            }
        }
}

#Preview {
    WorkoutView()
}
