import Foundation
import VitesseDomain
import XCTest
@testable import Candidates


@MainActor
class MockAPIService: APIServiceProtocol {
    var shouldReturnError = false
    var candidateToReturn: Candidate?
    var updateCandidateCalled = false
    var receivedCandidate: Candidate?
    var receivedToken: String?

    func updateCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    ) {
        updateCandidateCalled = true
        receivedCandidate = candidate
        receivedToken = token
        if shouldReturnError {
            completion(.failure(NSError(domain: "Test", code: -1, userInfo: nil)))
        } else {
            completion(.success(candidateToReturn ?? candidate))
        }
    }
}
