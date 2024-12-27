
// MARK: - ExerciseSearchReponse
struct ExerciseSearchReponse: Codable {
    let suggestions: [Suggestion]
}

// MARK: - Suggestion
struct Suggestion: Codable {
    let value: String
    let data: Exercise
}

// MARK: - Exercise
struct Exercise: Codable {
    let id, baseID: Int
    let name: String
    let category: String
    let image, imageThumbnail: String?

    enum CodingKeys: String, CodingKey {
        case id
        case baseID = "base_id"
        case name, category, image
        case imageThumbnail = "image_thumbnail"
    }
}
