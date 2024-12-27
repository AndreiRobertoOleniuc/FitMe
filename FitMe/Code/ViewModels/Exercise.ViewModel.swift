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
        Task{
            do{
                exercises = try await model.searchExercise(query: query)
            } catch{
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}
