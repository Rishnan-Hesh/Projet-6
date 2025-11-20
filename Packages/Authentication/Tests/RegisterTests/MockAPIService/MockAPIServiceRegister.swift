import XCTest
import VitesseData
@testable import Authentication

class MockRegisterAPIService {
    var shouldSucceed = true
    var lastRegisterRequest: RegisterRequest?

    func registerUser(request: RegisterRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        lastRegisterRequest = request
        if shouldSucceed {
            completion(.success(()))
        } else {
            completion(.failure(URLError(.badServerResponse)))
        }
    }
}
