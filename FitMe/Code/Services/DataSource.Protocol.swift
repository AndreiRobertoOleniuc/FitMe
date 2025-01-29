import Foundation

protocol DataSourceProtocol {
    func fetchWorkouts() -> [Workout]
    func updateOrAddWorkout(_ workout: Workout)
    func deleteWorkout(_ workout: Workout)
    func deleteExercise(_ exercise: Exercise)
    func fetchWorkoutSessions() -> [WorkoutSession]
    func addWorkoutSession(_ workoutSession: WorkoutSession)
    func deleteWorkoutSession(_ workoutSession: WorkoutSession)
    func save()
}
