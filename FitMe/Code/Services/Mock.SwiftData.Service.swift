class MockSwiftDataService: DataSourceProtocol {
    private(set) var workouts: [Workout] = []
    private(set) var workoutSessions: [WorkoutSession] = []
    
    init(initialWorkouts: [Workout] = [], initialWorkoutSessions: [WorkoutSession] = []) {
        self.workouts = initialWorkouts
        self.workoutSessions = initialWorkoutSessions
    }
    
    /// MARK: - Workouts
    func fetchWorkouts() -> [Workout] {
        return workouts
    }
    
    func updateOrAddWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index] = workout
        } else {
            workouts.append(workout)
        }
    }
    
    func deleteWorkout(_ workout: Workout) {
        workouts.removeAll { $0.id == workout.id }
    }
    
    func deleteExercise(_ exercise: Exercise) {
        for i in workouts.indices {
            workouts[i].exercises.removeAll { $0.id == exercise.id }
        }
    }
    
    /// MARK: - Workout Sessions
    func fetchWorkoutSessions() -> [WorkoutSession] {
        return workoutSessions
    }
    
    func addWorkoutSession(_ workoutSession: WorkoutSession) {
        if let index = workoutSessions.firstIndex(where: { $0.id == workoutSession.id }) {
            workoutSessions[index] = workoutSession
        } else {
            workoutSessions.append(workoutSession)
        }
    }
    
    func deleteWorkoutSession(_ workoutSession: WorkoutSession) {
        workoutSessions.removeAll { $0.id == workoutSession.id }
    }
    
    /// MARK: - Save
    func save() {
        // In a mock, we typically do nothing or simulate saving.
        // For now, it's a no-op.
    }
}
