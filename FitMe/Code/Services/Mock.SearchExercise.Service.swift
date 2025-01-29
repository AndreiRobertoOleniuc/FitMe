import Foundation

class MockSearchExerciseService: SearchExerciseProtocol {
    
    /// The array of suggestions returned by `searchExercise`.
    var mockSearchResults: [Suggestion] = []
    
    
    /// If `autoLoadMockData` is `true`, we parse the static JSON immediately into `mockSearchResults`.
    init(autoLoadMockData: Bool = true) {
        if autoLoadMockData {
            loadMockData()
        }
    }
    
    /// Asynchronously returns either the mock JSON data or throws an error.
    func searchExercise(query: String) async throws -> [Suggestion] {
        return mockSearchResults
    }
    
    // MARK: - Private Helpers
    
    /// Loads the static JSON from `mockJSON` into `mockSearchResults` using `JSONDecoder`.
    private func loadMockData() {
        let decoder = JSONDecoder()
        guard let data = Self.mockJSON.data(using: .utf8) else {
            return
        }
        
        do {
            let response = try decoder.decode(ExerciseSearchReponse.self, from: data)
            self.mockSearchResults = response.suggestions
        } catch {
            print("Failed to decode mock JSON: \(error)")
            self.mockSearchResults = []
        }
    }
    
    /// The static JSON
    private static let mockJSON = """
    {
      "suggestions": [
        {
          "value": "Squats",
          "data": {
            "id": 111,
            "base_id": 615,
            "name": "Squats",
            "category": "Legs",
            "image": null,
            "image_thumbnail": null
          }
        },
        {
          "value": "Lateral Raises",
          "data": {
            "id": 148,
            "base_id": 348,
            "name": "Lateral Raises",
            "category": "Shoulders",
            "image": "/media/exercise-images/148/lateral-dumbbell-raises-large-2.png",
            "image_thumbnail": "/media/exercise-images/148/lateral-dumbbell-raises-large-2.png.30x30_q85_crop-smart.jpg"
          }
        },
        {
          "value": "Lateral Raises",
          "data": {
            "id": 148,
            "base_id": 348,
            "name": "Lateral Raises",
            "category": "Shoulders",
            "image": "/media/exercise-images/148/lateral-dumbbell-raises-large-2.png",
            "image_thumbnail": "/media/exercise-images/148/lateral-dumbbell-raises-large-2.png.30x30_q85_crop-smart.jpg"
          }
        },
        {
          "value": "Flexión lateral",
          "data": {
            "id": 2144,
            "base_id": 1188,
            "name": "Flexión lateral",
            "category": "Abs",
            "image": "/media/exercise-images/1188/43e714e4-b736-4f3a-8ab4-97821fdff86a.jpg",
            "image_thumbnail": "/media/exercise-images/1188/43e714e4-b736-4f3a-8ab4-97821fdff86a.jpg.30x30_q85_crop-smart.jpg"
          }
        },
        {
          "value": "Lateral Push Off",
          "data": {
            "id": 2298,
            "base_id": 1325,
            "name": "Lateral Push Off",
            "category": "Legs",
            "image": "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg",
            "image_thumbnail": "/media/exercise-images/1325/d8372291-6725-452a-9711-6321c061e354.jpg.30x30_q85_crop-smart.jpg"
          }
        },
        {
          "value": "Split squats left",
          "data": {
            "id": 1643,
            "base_id": 991,
            "name": "Split squats left",
            "category": "Legs",
            "image": null,
            "image_thumbnail": null
          }
        }
      ]
    }
    """
}
