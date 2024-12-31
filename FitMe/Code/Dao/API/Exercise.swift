import Foundation

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
struct Exercise: Codable, Identifiable {
    let id: Int
    let baseID: Int
    let name: String
    let category: String
    let image, imageThumbnail: String?
    var sets: Int = 3
    var reps: Int = 12
    var rest: Int = 60

    init(id: Int, baseID: Int, name: String, category: String, image: String, imageThumbnail: String?) {
        self.id = id
        self.baseID = id
        self.name = name
        self.category = category
        self.image = image
        self.imageThumbnail = imageThumbnail
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case baseID = "base_id"
        case name
        case category
        case image
        case imageThumbnail = "image_thumbnail"
    }
}
