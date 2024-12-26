struct ExerciseSuggestion: Codable, Identifiable {
    var id: Int { data.id } // Add an id property for Identifiable conformance
    var value: String
    var data: Exercise
}

struct ExerciseSearchResponse: Codable {
    var suggestions: [ExerciseSuggestion]
}

struct Exercise: Codable {
    var id: Int
    var baseId: Int
    var name: String
    var category: String
    var image: String?
    var imageThumbnail: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case baseId = "base_id"
        case name
        case category
        case image
        case imageThumbnail = "image_thumbnail"
    }
}