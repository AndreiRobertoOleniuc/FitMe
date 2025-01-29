import Testing
import Foundation

@testable import FitMe

@MainActor
struct FitMeTests {

    @Test func testSortingOfWorkoutsByNameTest() throws {
        // Arrange
        let mockDataSource = MockSwiftDataService(initialWorkouts: [
            Workout(name: "Leg Day", workoutDescription: "All legs"),
            Workout(name: "Arm Day", workoutDescription: "Biceps, triceps")
        ])
        let mockSearch = MockSearchExerciseService()
        
        let viewModel = WorkoutViewModel(
            searchExerciseModel: mockSearch,
            dataSource: mockDataSource
        )
        
        // Act
        viewModel.fetchWorkouts()

        // Assert
        #expect(viewModel.workouts.count == 2)
        #expect(viewModel.workouts.first?.name == "Arm Day")
    }
    
    @Test func addNewWorkoutTest() throws {
        // Arrange
        let mockDataSource = MockSwiftDataService(initialWorkouts: [
            Workout(name: "Leg Day", workoutDescription: "All legs"),
            Workout(name: "Arm Day", workoutDescription: "Biceps, triceps")
        ])
        let mockSearch = MockSearchExerciseService()
        
        let viewModel = WorkoutViewModel(
            searchExerciseModel: mockSearch,
            dataSource: mockDataSource
        )
        
        // Act
        viewModel.newWorkoutName = "Test"
        viewModel.newWorkoutDescription = "Test"
        
        viewModel.addWorkout()
        
        viewModel.fetchWorkouts()

        // Assert
        #expect(viewModel.workouts.count == 3)
        #expect(viewModel.newWorkoutName == "")
        #expect(viewModel.newWorkoutDescription == "")
    }
    
    @Test func deleteWorkoutTest() throws {
        // Arrange
        let mockDataSource = MockSwiftDataService(initialWorkouts: [
            Workout(name: "Leg Day", workoutDescription: "All legs"),
            Workout(name: "Arm Day", workoutDescription: "Biceps, triceps"),
            Workout(name: "Test", workoutDescription: "Test")
        ])
        let mockSearch = MockSearchExerciseService()
        
        let viewModel = WorkoutViewModel(
            searchExerciseModel: mockSearch,
            dataSource: mockDataSource
        )

        // Act
        viewModel.fetchWorkouts()
        viewModel.deleteWorkout(at: IndexSet(integer: 0))
        

        // Assert
        #expect(viewModel.workouts.count == 2)
    }
    
    @Test func addExerciseToWorkoutTest() throws {
        // Arrange
        let mockDataSource = MockSwiftDataService(initialWorkouts: [
            Workout(name: "Leg Day", workoutDescription: "All legs")
        ])
        let mockSearch = MockSearchExerciseService()
        
        let viewModel = WorkoutViewModel(
            searchExerciseModel: mockSearch,
            dataSource: mockDataSource
        )

        // Act
        viewModel.fetchWorkouts()
        let workout = viewModel.workouts[0]
        viewModel.addExerciseToWorkout(ExerciseAPI(id: 2298, baseID: 1325, name:"Lateral Push Off", category: "Legs", image: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg", imageThumbnail: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg.30x30_q85_crop-smart.jpg"), to: workout)
        
        
        // Assert
        #expect(viewModel.workouts[0].exercises.count == 1)
    }
    
    @Test func updateExerciseInWorkoutTest() throws {
        // Arrange
        let mockDataSource = MockSwiftDataService(initialWorkouts: [
            Workout(name: "Leg Day", workoutDescription: "All legs")
        ])
        let mockSearch = MockSearchExerciseService()
        
        let viewModel = WorkoutViewModel(
            searchExerciseModel: mockSearch,
            dataSource: mockDataSource
        )

        // Act
        viewModel.fetchWorkouts()
        let workout = viewModel.workouts[0]
        viewModel.addExerciseToWorkout(ExerciseAPI(id: 2298, baseID: 1325, name:"Lateral Push Off", category: "Legs", image: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg", imageThumbnail: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg.30x30_q85_crop-smart.jpg"), to: workout)
        
        let exercise = viewModel.workouts[0].exercises[0]
        exercise.sets = 5
        viewModel.updateExerciseInWorkout(exercise, to: workout)
        
    
        // Assert
        #expect(viewModel.workouts[0].exercises[0].sets == 5)
    }
    
    
    @Test func deleteExerciseFromWorkoutTest() throws {
        // Arrange
        let mockDataSource = MockSwiftDataService(initialWorkouts: [
            Workout(name: "Leg Day", workoutDescription: "All legs")
        ])
        let mockSearch = MockSearchExerciseService()
        
        let viewModel = WorkoutViewModel(
            searchExerciseModel: mockSearch,
            dataSource: mockDataSource
        )

        // Act
        viewModel.fetchWorkouts()
        let workout = viewModel.workouts[0]
        viewModel.addExerciseToWorkout(ExerciseAPI(id: 2298, baseID: 1325, name:"Lateral Push Off", category: "Legs", image: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg", imageThumbnail: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg.30x30_q85_crop-smart.jpg"), to: workout)
        
        viewModel.addExerciseToWorkout(ExerciseAPI(id: 2299, baseID: 1326, name:"Lateral Raises", category: "Shoulders", image: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg", imageThumbnail: "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg.30x30_q85_crop-smart.jpg"), to: workout)
        
        viewModel.deleteExerciseFromWorkout(at: IndexSet(integer: 0), to: workout)
        
    
        // Assert
        #expect(viewModel.workouts[0].exercises.count == 1)
    }
}
