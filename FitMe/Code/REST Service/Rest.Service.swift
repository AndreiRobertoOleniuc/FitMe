import Foundation

// MARK: - Implementation of the REST Service Protocol

final class RestService: DataServiceProtocol {
    let baseURL: String
    private var globalHeaders: [String: String] = [:]
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    func addGlobalHeaderEntry(key: String, value: String) {
        globalHeaders[key] = value
    }
    
    func request<RESULTTYPE: Decodable>(endpoint: Endpoint) async throws -> RESULTTYPE {
        try await performRequest(endpoint: endpoint, body: EmptyBody())
    }
    
    func request<RESULTTYPE: Decodable, BODYTYPE: Encodable>(endpoint: Endpoint, body: BODYTYPE) async throws -> RESULTTYPE {
        return try await performRequest(endpoint: endpoint, body: body)
    }
    
    private func performRequest<RESULTTYPE: Decodable, BODYTYPE: Encodable>(endpoint: Endpoint, body: BODYTYPE) async throws -> RESULTTYPE {
        var urlComponents = URLComponents(string: baseURL + endpoint.path)
       
        if let queryItems = endpoint.queryItems {
            urlComponents?.queryItems = queryItems
        }
      
        guard let url = urlComponents?.url else {
            throw RestError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
       
        // Set Global Headers
        for (key, value) in globalHeaders {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Set Content Type
        if !(body is EmptyBody) {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if !(body is EmptyBody) {
            request.httpBody = try JSONEncoder().encode(body)
        }
    
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
           
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RestError.unknown
            }
            
            if !(200 ..< 300).contains(httpResponse.statusCode) {
                throw RestError.httpError(httpResponse.statusCode)
            }
            
//            let decodedData = try JSONDecoder().decode(RESULTTYPE.self, from: data)
            let decodedData = try JSONDecoder().decodeWithDetailedErrors(
                RESULTTYPE.self,
                from: data
            )
            return decodedData
        }
        catch let error as DecodingError {
            throw error
        }
        catch {
            throw RestError.networkError(error)
        }
    }
}
