import Foundation

protocol BaseAPIServiceProtocol {
    func sendRequest<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        parameters: U?,
        headers: [String: String]?,
        decodingType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    )
}

final public class BaseAPIService: BaseAPIServiceProtocol {
    public static let shared = BaseAPIService()
    public init() {}
    
    public func sendRequest<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        parameters: U? = nil,
        headers: [String: String]? = nil,
        decodingType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let headers = headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONEncoder().encode(parameters)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(NetworkError.encodingFailed))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(decodingType, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(NetworkError.decodingFailed))
            }
        }
        task.resume()
    }
}
