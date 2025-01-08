import SwiftData
import Foundation

@Model
final class ActiveWorkout {
    var id: UUID
    var workout: Workout
    var date: Date
    var duration: TimeInterval
    var completed: Bool = false
    
    init(workout: Workout, date: Date, duration: TimeInterval) {
        self.id = UUID()
        self.workout = workout
        self.date = date
        self.duration = duration
    }
}
