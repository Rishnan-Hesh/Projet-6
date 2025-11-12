import Foundation
import VitesseDomain
import XCTest
@testable import Candidates

@MainActor
final class MockCandidateService: CandidateServiceProtocol {
    var shouldFetchSucceed = true
    var shouldCreateSucceed = true
    var shouldDeleteSucceed = true
    var shouldUpdateSucceed = true
    var lastCreatedCandidate: Candidate?
    var lastUpdatedCandidate: Candidate?
    var lastDeletedIds: [String] = []
    var candidatesToReturn: [Candidate] = []

    func fetchCandidates(
        token: String,
        completion: @escaping @Sendable (Result<[Candidate], Error>) -> Void
    ) {
        if shouldFetchSucceed {
            completion(.success(candidatesToReturn))
        } else {
            completion(.failure(URLError(.badServerResponse)))
        }
    }

    func createCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    ) {
        lastCreatedCandidate = candidate
        if shouldCreateSucceed {
            completion(.success(candidate))
        } else {
            completion(.failure(URLError(.badServerResponse)))
        }
    }

    func deleteCandidate(
        candidateId: String,
        token: String,
        completion: @escaping @Sendable (Result<Void, Error>) -> Void
    ) {
        lastDeletedIds.append(candidateId)
        if shouldDeleteSucceed {
            completion(.success(()))
        } else {
            completion(.failure(URLError(.cannotRemoveFile)))
        }
    }

    func updateCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    ) {
        lastUpdatedCandidate = candidate
        if shouldUpdateSucceed {
            completion(.success(candidate))
        } else {
            completion(.failure(URLError(.cannotWriteToFile)))
        }
    }
}
