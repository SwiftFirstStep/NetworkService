import XCTest
@testable import NetworkService

final class NetworkServiceTests: XCTestCase {
    func testSuccessfulRequest() {
        let apiService = BaseAPIService.shared
        let expectation = self.expectation(description: "Successful Request")
        
        struct MockResponse: Decodable {
            let message: String
        }
        
        apiService.sendRequest(
            endpoint: "https://jsonplaceholder.typicode.com/posts/1",
            method: .get,
            parameters: Optional<String>.none,
            headers: nil,
            decodingType: MockResponse.self
        ) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(response.message, "expected message")
            case .failure:
                XCTFail("Request failed unexpectedly")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testInvalidURL() {
        let apiService = BaseAPIService.shared
        let expectation = self.expectation(description: "Invalid URL")
        
        struct MockResponse: Decodable {}
        
        apiService.sendRequest(
            endpoint: "invalid-url",
            method: .get,
            parameters: Optional<String>.none,
            headers: nil,
            decodingType: MockResponse.self
        ) { result in
            switch result {
            case .success:
                XCTFail("Request should fail with invalid URL")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidURL)
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
