import Foundation

enum DecodingErrorDescription: Error, LocalizedError {
    case missingKey(String)
    case typeMismatch(expected: String, actual: String)
    case valueNotFound(String)
    case corruptedData
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .missingKey(let key):
            return "Required key '\(key)' not found."
        case .typeMismatch(let expected, let actual):
            return "Expected type '\(expected)' doesn't match the received type '\(actual)'."
        case .valueNotFound(let type):
            return "Expected value of type '\(type)' is missing."
        case .corruptedData:
            return "The data appears to be corrupted."
        case .unknownError(let message):
            return "Unknown decoding error: \(message)"
        }
    }
}

