import Foundation

@MainActor
class ExerciseViewModel: ObservableObject {
    private let model: ExerciseModel
    
    init(dataService: DataServiceProtocol) {
        self.model = ExerciseModel(dataService: dataService)
    }
    
    @Published var exercises: [Suggestion] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func fetchExercises(query: String){
        isLoading = true
        Task {
            do {
                let fetchedSuggestions = try await model.searchExercise(query: query)
                exercises = fetchedSuggestions.map { suggestion in
                    Suggestion(
                        value: suggestion.value,
                        data: Exercise(
                            id: suggestion.data.id,
                            baseID: suggestion.data.baseID,
                            name: suggestion.data.name,
                            category: suggestion.data.category,
                            image: suggestion.data.image.map { "https://wger.de\($0)" } ?? "",
                            imageThumbnail: suggestion.data.imageThumbnail.map { "https://wger.de\($0)" }
                        )
                    )
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
