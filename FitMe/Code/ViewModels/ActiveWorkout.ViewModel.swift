import Foundation
import SwiftData

@MainActor
class ActiveWorkoutViewModel: ObservableObject {
    private let dataSource: SwiftDataService
    
    init(dataSource: SwiftDataService) {
        self.dataSource = dataSource
    }
    
    @Published var workoutSessions: [WorkoutSession] = []
    @Published var availabileWorkouts: [Workout] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    var activeSession: WorkoutSession? {
        workoutSessions.first(where: { $0.isActive })
    }
    
    func fetchAllWorkoutSessions() {
        workoutSessions = dataSource.fetchWorkoutSessions()
    }
    
    func startWorkoutSession(_ workout: Workout) {
        if let activeWorkout = workoutSessions.first(where: { $0.isActive }){
            if(activeWorkout.workout.id == workout.id){
                return
            }
            activeWorkout.isActive = false
            dataSource.save()
        }
        let newWorkoutSession = WorkoutSession(workout: workout,startTime: Date(), isActive: true)
        dataSource.addWorkoutSession(newWorkoutSession)
        fetchAllWorkoutSessions()
    }
    
    func stopWorkoutSession() {
        let activeWorkouts = workoutSessions.filter { $0.isActive }
        activeWorkouts.forEach { workout in
            workout.isActive = false
        }
        dataSource.save()
        fetchAllWorkoutSessions()
    }
    
    func findAllPossibleWorkouts() {
        availabileWorkouts = dataSource.fetchWorkouts()
    }
}
