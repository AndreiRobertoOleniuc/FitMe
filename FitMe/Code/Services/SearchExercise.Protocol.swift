protocol SearchExerciseProtocol {
    func searchExercise(query: String) async throws -> [Suggestion]
}
