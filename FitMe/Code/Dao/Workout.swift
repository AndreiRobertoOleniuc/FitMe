import Foundation
import SwiftData

@Model
final class Workout: Identifiable {
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
        exercise.order = exercises.count
        exercises.append(exercise)
    }
}
