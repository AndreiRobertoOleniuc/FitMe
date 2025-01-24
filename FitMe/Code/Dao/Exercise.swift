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
    var weight: Double = 20
    var order: Int = 0
    var systemImage: String = "dumbbell.fill"

    init(id: Int, baseID: Int, name: String, category: String, image: String?, imageThumbnail: String?) {
        self.id = id
        self.baseID = baseID
        self.name = name
        self.category = category
        self.image = image
        self.imageThumbnail = imageThumbnail
        if imageThumbnail == nil{
            self.systemImage = getSystemImageName(category)
        }
    }
    
    private func getSystemImageName(_ category: String?) -> String {
        switch category {
        case "Abs":
            return "figure.core.training"
        case "Arms":
            return "dumbbell.fill"
        case "Back":
            return "figure.strengthtraining.functional"
        case "Calves":
            return "figure.walk"
        case "Cardio":
            return "heart.fill"
        case "Chest":
            return "figure.strengthtraining.functional"
        case "Legs":
            return "figure.run"
        case "Shoulders":
            return "figure.strengthtraining.functional"
        default:
            return "dumbbell.fill"
        }
    }
}
