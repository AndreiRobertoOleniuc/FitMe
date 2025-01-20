import SwiftData
import Foundation

@Model
final class PerformedExercise {
    var id: Int
    var baseID: Int
    var name: String
    var category: String
    var image: String?
    var imageThumbnail: String?
    var sets: Int = 3
    var reps: Int = 12
    var rest: Int = 60
    var weight: Double = 20
    var order: Int = 0
    
    init(id: Int,baseID: Int, name: String, category: String, image: String? = nil, imageThumbnail: String? = nil, sets: Int, reps: Int, rest: Int, weight: Double, order: Int) {
        self.id = id
        self.baseID = baseID
        self.name = name
        self.category = category
        self.image = image
        self.imageThumbnail = imageThumbnail
        self.sets = sets
        self.reps = reps
        self.rest = rest
        self.weight = weight
        self.order = order
    }
    

}
