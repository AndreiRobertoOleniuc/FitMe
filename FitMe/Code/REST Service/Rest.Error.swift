import Foundation

// MARK: - Error Handling

enum RestError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case httpError(Int)
    case unknown
}
