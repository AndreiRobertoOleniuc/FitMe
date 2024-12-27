class ExerciseModel {
    let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func searchExercise(query: String) async throws -> [Suggestion] {
        let exercises: ExerciseSearchReponse = try await dataService.request(endpoint: WgetFitnessAPI.searchExercise(query: query))
        return exercises.suggestions
    }
}
