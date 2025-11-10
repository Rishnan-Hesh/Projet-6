import SwiftUI
import VitesseDomain
import VitesseData

@MainActor
final class CandidateDetailsViewModel: ObservableObject {
    @Published var candidate: Candidate
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init(candidate: Candidate) {
        self.candidate = candidate
    }

    func updateCandidate(token: String, completion: @escaping @Sendable (Result<Candidate, Error>) -> Void) {
        isLoading = true
        APIService.shared.updateCandidate(candidate: candidate, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedCandidate):
                    self?.candidate = updatedCandidate
                    completion(.success(updatedCandidate))
                case .failure(let error):
                    self?.errorMessage = "Erreur lors de la modification"
                    completion(.failure(error))
                }
            }
        }
    }

    //Pour édition locale sans API
    func updateCandidateLocal(_ updated: Candidate) {
        self.candidate = updated
    }
}

