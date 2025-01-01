import SwiftData

@Model
final class Exercise {
    var id: Int
    var baseID: Int
    var name: String
    var category: String
    var image: String?
    var imageThumbnail: String?
    var sets: Int = 3
    var reps: Int = 12
    var rest: Int = 60

    init(id: Int, baseID: Int, name: String, category: String, image: String?, imageThumbnail: String?) {
        self.id = id
        self.baseID = baseID
        self.name = name
        self.category = category
        self.image = image
        self.imageThumbnail = imageThumbnail
    }
}
