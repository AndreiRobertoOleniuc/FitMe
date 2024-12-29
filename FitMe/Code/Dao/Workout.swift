import Foundation
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

@Model
final class WorkoutDataModel: Identifiable {
    var id: UUID
    var name: String
    var workoutDescription: String
    @Relationship(deleteRule: .cascade) var exercises: [Exercise] = []

    init(name: String, workoutDescription: String) {
        self.id = UUID()
        self.name = name
        self.workoutDescription = workoutDescription
    }
    
    func addExercise(_ exercise: Exercise) {
        exercises.append(exercise)
    }
}
