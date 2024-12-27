import Foundation

// MARK: - Endpoint Protocol
protocol Endpoint {
    var path: String { get }
    var method: String { get }
    var responseType: Decodable.Type { get }
    var bodyType: Encodable.Type { get }
    var queryItems: [URLQueryItem]? { get }
    
    var mockFilename: String? { get }
}
