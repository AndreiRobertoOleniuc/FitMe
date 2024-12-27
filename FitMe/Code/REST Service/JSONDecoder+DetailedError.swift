import Foundation

extension JSONDecoder {
    func decodeWithDetailedErrors<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try self.decode(type, from: data)
        } catch let DecodingError.keyNotFound(key, _) {
            throw DecodingErrorDescription.missingKey(key.stringValue)
        } catch let DecodingError.typeMismatch(expectedType, context) {
            throw DecodingErrorDescription.typeMismatch(
                expected: "\(expectedType)",
                actual: "\(context.codingPath.last?.stringValue ?? "unknown")"
            )
        } catch let DecodingError.valueNotFound(valueType, _) {
            throw DecodingErrorDescription.valueNotFound("\(valueType)")
        } catch DecodingError.dataCorrupted {
            throw DecodingErrorDescription.corruptedData
        } catch {
            throw DecodingErrorDescription.unknownError(error.localizedDescription)
        }
    }
}
