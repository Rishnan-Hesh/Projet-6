import Foundation
import VitesseDomain
import VitesseData
import XCTest
@testable import Authentication

class MockAPIService: AuthenticationServiceProtocol, @unchecked Sendable {
    var shouldSucceed = true
    var lastAuthEmail: String?
    var lastAuthPassword: String?
    var response: AuthResponse = AuthResponse(token: "mockToken", isAdmin: false)
    
    func authenticate(
        email: String,
        password: String,
        completion: @escaping @Sendable (Result<AuthResponse, Error>) -> Void
    ) {
        lastAuthEmail = email
        lastAuthPassword = password
        if shouldSucceed {
            completion(.success(response))
        } else {
            completion(.failure(URLError(.userAuthenticationRequired)))
        }
    }
}

