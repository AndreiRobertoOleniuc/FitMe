import Foundation

// MARK: - REST Service Protocol
protocol DataServiceProtocol {
    var baseURL: String { get }

    func addGlobalHeaderEntry(key: String, value: String)

    func request<RESULTTYPE: Decodable>(endpoint: Endpoint) async throws -> RESULTTYPE
    
    func request<RESULTTYPE: Decodable, BODYTYPE: Encodable>(endpoint: Endpoint, body: BODYTYPE) async throws -> RESULTTYPE
}

