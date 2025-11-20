import SwiftUI
import VitesseDomain
import VitesseData

//MARK: - Properties
@MainActor
public protocol APIServiceProtocol {
    func updateCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    )
}

// Extension pour rendre le singleton utilisable comme APIServiceProtocol
extension APIService: APIServiceProtocol {}

@MainActor
final class CandidateDetailsViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let apiService: APIServiceProtocol
    
    // Injection, soit APIService ou mock pour tests
    init(candidate: Candidate, apiService: APIServiceProtocol = APIService.shared) {
        self.candidate = candidate
        self.apiService = apiService
    }
    
    func updateCandidate(token: String, completion: @escaping @Sendable (Result<Candidate, Error>) -> Void) {
        isLoading = true
        apiService.updateCandidate(candidate: candidate, token: token) { [weak self] result in
            guard let self = self else { return }
            Task { @MainActor in
                self.isLoading = false
                switch result {
                case .success(let updatedCandidate):
                    self.candidate = updatedCandidate
                    completion(.success(updatedCandidate))
                case .failure(let error):
                    self.errorMessage = "Something went wrong. Please try again."
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateCandidateLocal(_ updated: Candidate) {
        self.candidate = updated
    }
}
