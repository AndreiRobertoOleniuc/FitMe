import Foundation

enum WgetFitnessAPI: Endpoint {
    case searchExercise(query: String)
    
    var path: String{
        switch self{
            case .searchExercise(let query): return "/search/?language=en&term=\(query)"
        }
    }
    
    var method: String{
        switch self{
            case .searchExercise: return "GET"
        }
    }
    
    var responseType: Decodable.Type {
        switch self{
            case .searchExercise: return ExerciseSearchReponse.self
        }
    }
    
    var bodyType: Encodable.Type {
        switch self{
            case .searchExercise: return EmptyBody.self
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var mockFilename: String? {
        return nil

    }
}

