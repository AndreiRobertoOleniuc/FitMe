import SwiftData
import Foundation

@Model
final class WorkoutSession {
    @Attribute(.unique) var id: UUID = UUID()
    var workout: Workout
    var startTime: Date?
    var isActive: Bool = false
    var completedExecises: [Int] = []
    var currentExercise: Int = 0
    var performedExercises: [PerformedExercise] = []
    
    init(workout: Workout, startTime: Date? = nil, isActive: Bool = false) {
        self.workout = workout
        self.startTime = startTime
        self.isActive = isActive
        self.performedExercises = workout.exercises.map { exercise in
            PerformedExercise(
                id: exercise.id,
                baseID: exercise.baseID,
                name: exercise.name,
                category: exercise.category,
                image: exercise.image,
                imageThumbnail: exercise.imageThumbnail,
                sets: exercise.sets,
                reps: exercise.reps,
                rest: exercise.rest,
                weight: exercise.weight,
                order: exercise.order
            )
        }
    }
}

