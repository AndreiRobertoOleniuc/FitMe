import SwiftData

@Model
final class ExerciseDataModel: Identifiable {
    var id: Int
    var baseID: Int
    var name: String
    var category: String
    var image: String?
    var imageThumbnail: String?
    
    init(id: Int, baseID: Int, name: String, category: String, image: String?, imageThumbnail: String?) {
        self.id = id
        self.baseID = id
        self.name = name
        self.category = category
        self.image = image
        self.imageThumbnail = imageThumbnail
    }
}
