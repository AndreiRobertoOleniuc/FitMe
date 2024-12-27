import Foundation

// MARK: - Mock REST Service for Testing

class MockRestService: DataServiceProtocol {
    var baseURL: String = "https://mock.api.com"
    private var globalHeaders: [String: String] = [:]
    private var injectedData: Data? = nil
    var addDelay = false
    var shouldFail = false
    var mockError: NSError = .init(domain: "MockError", code: 0, userInfo: nil)
    
    func addGlobalHeaderEntry(key: String, value: String) {
        globalHeaders[key] = value
    }
    
    func request<RESULTTYPE: Decodable>(endpoint: Endpoint) async throws -> RESULTTYPE {
        try await request(endpoint: endpoint, body: EmptyBody())
    }
    
    func request<RESULTTYPE: Decodable, BODYTYPE: Encodable>(endpoint: Endpoint, body: BODYTYPE) async throws -> RESULTTYPE {
        if shouldFail {
            throw mockError
        }

        var data: Data?
        
        if let injectedData {
            data = injectedData
        } else if let fromJson = readJsonFile(for: endpoint) {
            data = fromJson
        } else {
            data = "{}".data(using: .utf8)
        }
        
        // Handle mock file cases
        guard let data else {
            throw RestError.decodingError(
                DecodingError.dataCorrupted(
                    DecodingError.Context(
                        codingPath: [],
                        debugDescription: "No mock data found for \(endpoint.mockFilename ?? "")"
                    )
                )
            )
        }
        
        try await Task.sleep(nanoseconds: addDelay ? 1_000_000_000 : 0)
      
        do {
            let result = try JSONDecoder().decode(RESULTTYPE.self, from: data)
            
            return result
        } catch {
            throw RestError.decodingError(error)
        }
    }
    
    static func readJsonFile(from bundleJSONFileName: String) -> Data? {
        if let url = Bundle.main.url(
            forResource: bundleJSONFileName, withExtension: ""
        ) {
            return try? Data(contentsOf: url)
        }
        return nil
    }
    
    private func readJsonFile(for endpoint: Endpoint) -> Data? {
        guard let mockFilename = endpoint.mockFilename else { return nil }
        return MockRestService.readJsonFile(from: mockFilename)
    }
    
    func injectData(fromFile fileName: String) {
        injectedData = MockRestService.readJsonFile(from: fileName)
    }
    
    func injectData(_ data: Data?) {
        injectedData = data
    }
}
