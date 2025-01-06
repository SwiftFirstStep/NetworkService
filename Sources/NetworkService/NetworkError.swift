import Foundation

public enum NetworkError: Error, Equatable {
    case invalidURL
    case noData
    case decodingFailed
    case custom(String)
    case encodingFailed
}
