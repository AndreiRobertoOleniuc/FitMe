import Foundation
import SwiftData
import SwiftUI

@MainActor
class ActiveWorkoutViewModel: ObservableObject {
    private let dataSource: DataSourceProtocol
    
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

    func findAllPossibleWorkouts() {
        availabileWorkouts = dataSource.fetchWorkouts().filter { workout in
            if workout.exercises.isEmpty {
                return false
            }
            return true
        }.sorted(by: { $0.name < $1.name })
    }
    
    func getNextWorkoutSuggestion() -> Workout? {
        // Get last workout session
        guard let lastSession = workoutSessions
            .filter({ !$0.isActive })
            .sorted(by: { ($0.startTime ?? Date()) > ($1.startTime ?? Date()) })
            .first else {
            return availabileWorkouts.first
        }
        
        // Find index of last workout
        guard let currentIndex = availabileWorkouts.firstIndex(where: { $0.id == lastSession.workout.id }) else {
            return availabileWorkouts.first
        }
        
        // Get next workout, or wrap around to first
        let nextIndex = (currentIndex + 1) % availabileWorkouts.count
        return availabileWorkouts[nextIndex]
    }
    
    /// Active Workout Functionality
    func toggleCompletedExercise(_ index: Int){
        if let activeSession{
            if activeSession.completedExecises.contains(index){
                activeSession.completedExecises.removeAll { $0 == index }
            } else {
                activeSession.completedExecises.append(index)
                nextExercise()
            }
            dataSource.save()
        }
    }
       
    func nextExercise(){
        if let activeSession {
            if activeSession.currentExercise < activeSession.workout.exercises.count - 1{
                withAnimation(.easeInOut){
                    activeSession.currentExercise += 1
                    dataSource.save()
                }
            }
        }
    }
       
    func previousExercise(){
        if let activeSession {
            if activeSession.currentExercise > 0{
                withAnimation(.easeInOut){
                    activeSession.currentExercise -= 1
                    dataSource.save()
                }
            }
        }
    }
    
    func setCurrentExercise(_ index: Int){
        if let activeSession {
            activeSession.currentExercise = index
            dataSource.save()
        }
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
    
    
    func calculateTotalVolume() -> Int {
        guard let activeSession = activeSession else { return 0 }
        return activeSession.completedExecises.reduce(0) { total, index in
            let exercise = activeSession.workout.exercises[index]
            return total + Int(exercise.weight * Double(exercise.sets * exercise.reps))
        }
    }
    
    ///Timer Functionality
    @Published var elapsedTime: TimeInterval = 0
    private var timer: Timer?

    func startTimer() {
        guard let startTime = activeSession?.startTime else { return }
        timer?.invalidate()
        elapsedTime = Date().timeIntervalSince(startTime)
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.elapsedTime = Date().timeIntervalSince(startTime)
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
