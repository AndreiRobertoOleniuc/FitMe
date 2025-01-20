import Foundation
import SwiftData

@MainActor
class StatsViewModel: ObservableObject {
    private let dataSource: SwiftDataService
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
    }
    
    @Published var workoutSessions: [WorkoutSession] = []

    func fetchAllWorkoutSessions() {
        workoutSessions = dataSource.fetchWorkoutSessions()
    }
    
    func deleteWorkoutSession(_ session: WorkoutSession) {
        dataSource.deleteWorkoutSession(session)
        fetchAllWorkoutSessions()
    }
    
    func calculateTotalVolumeForSession(_ session: WorkoutSession) -> Int {
        session.completedExecises.reduce(0) { total, index in
            if index < session.performedExercises.count {
                let exercise = session.performedExercises[index]
                return total + Int(exercise.weight * Double(exercise.sets * exercise.reps))
            }
            return total
        }
    }
    
    // Workout Frequency
    func getWorkoutsPerWeek() -> [Date: Int] {
        Dictionary(grouping: workoutSessions, by: { Calendar.current.startOfWeek(for: $0.startTime ?? Date()) })
            .mapValues { $0.count }
    }
    
    // Volume Progress
    func getVolumeProgress() -> [(Date, Int)] {
        workoutSessions
            .sorted(by: { ($0.startTime ?? Date()) < ($1.startTime ?? Date()) })
            .map { session in
                (session.startTime ?? Date(), calculateTotalVolumeForSession(session))
            }
    }
    
    // Most Popular Exercises
    func getMostPopularExercises() -> [(String, Int)] {
        let allExercises = workoutSessions.flatMap { $0.performedExercises }
        return Dictionary(grouping: allExercises, by: { $0.name })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
    }
    
    // Average Weight Progress Per Exercise
    func getWeightProgressForExercise(named exerciseName: String) -> [(Date, Double)] {
        workoutSessions
            .sorted(by: { ($0.startTime ?? Date()) < ($1.startTime ?? Date()) })
            .compactMap { session -> (Date, Double)? in
                guard let exercise = session.performedExercises.first(where: { $0.name == exerciseName }),
                      let date = session.startTime
                else { return nil }
                return (date, exercise.weight)
            }
    }
    
    func getAllCategories() -> [String] {
        let allExercises = workoutSessions.flatMap { $0.performedExercises }
        let categories = Set(allExercises.map { $0.category })
        return Array(categories).sorted()
    }
    
    /// Returns all unique exercise names for a given category.
    func getExercises(for category: String) -> [String] {
        let allExercises = workoutSessions
            .flatMap { $0.performedExercises }
            .filter { $0.category == category }
        
        let uniqueNames = Set(allExercises.map { $0.name })
        return Array(uniqueNames).sorted()
    }

    func didUserWorkout(on date: Date) -> Bool {
        let startOfDay = Calendar.current.startOfDay(for: date)
        return workoutSessions.contains { session in
            if let sessionDate = session.startTime {
                return Calendar.current.startOfDay(for: sessionDate) == startOfDay
            }
            return false
        }
    }

}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}
