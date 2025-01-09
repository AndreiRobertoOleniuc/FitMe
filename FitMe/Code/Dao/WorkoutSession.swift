import SwiftData
import Foundation

@Model
final class WorkoutSession {
    @Attribute(.unique) var id: UUID = UUID()
    var workout: Workout
    var startTime: Date?
    var isActive: Bool = false
    
    init(workout: Workout, startTime: Date? = nil, isActive: Bool = false) {
        self.workout = workout
        self.startTime = startTime
        self.isActive = isActive
    }
}
