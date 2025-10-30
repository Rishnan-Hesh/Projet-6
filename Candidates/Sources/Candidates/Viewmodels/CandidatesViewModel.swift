import SwiftUI
import VitesseDomain

@MainActor
final class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isEditing: Bool = false
    @Published var searchText: String = ""
    
    @Published var showFavoritesOnly = false
    @Published var selection = Set<String>()
    
    // Filter
    var filteredCandidates: [Candidate] {
        var filtered = candidates
        
        if showFavoritesOnly {
            filtered = filtered.filter { $0.isFavorite }
        }
        
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.firstName.localizedCaseInsensitiveContains(searchText) }
        }
        
        return filtered
    }
    
    
    // MARK: - Actions
    
    func toggleEditMode() {
        isEditing.toggle()
    }
    
    func loadCandidates(token: String) {
        isLoading = true
        errorMessage = nil
        APIService.shared.fetchCandidates(token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let candidates):
                    self?.candidates = candidates
                case .failure:
                    self?.errorMessage = "Impossible de charger les candidats"
                }
            }
        }
    }
    
    func deleteCandidates(withIds ids: Set<String>, token: String) {
        isLoading = true
        errorMessage = nil
        let group = DispatchGroup()
        var failedIds = [String]()
        for id in ids {
            group.enter()
            APIService.shared.deleteCandidate(candidateId: id, token: token) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.candidates.removeAll { $0.id == id }
                    }
                case .failure:
                    failedIds.append(id)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
            if !failedIds.isEmpty {
                self?.errorMessage = "Erreur lors de la suppression de certains candidats"
            }
        }
    }
    
    func deleteCandidate(withId id: String, token: String) {
        deleteCandidates(withIds: [id], token: token)
    }
    
    func updateCandidate(_ candidate: Candidate, token: String) {
        isLoading = true
        APIService.shared.updateCandidate(candidate: candidate, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedCandidate):
                    if let index = self?.candidates.firstIndex(where: { $0.id == candidate.id }) {
                        self?.candidates[index] = updatedCandidate
                    }
                case .failure:
                    self?.errorMessage = "Erreur lors de la modification"
                }
            }
        }
    }

    
    func toggleFavorite(for candidate: Candidate, token: String) {
        var updated = candidate
        updated.isFavorite.toggle()
        isLoading = true
        APIService.shared.updateCandidate(candidate: updated, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedCandidate):
                    if let index = self?.candidates.firstIndex(where: { $0.id == candidate.id }) {
                        self?.candidates[index] = updatedCandidate
                    }
                case .failure:
                    self?.errorMessage = "Erreur lors de la mise à jour du favori"
                }
            }
        }
    }
    
    func toggleSelection(_ candidate: Candidate) {
        if selection.contains(candidate.id) {
            selection.remove(candidate.id)
        } else {
            selection.insert(candidate.id)
        }
    }
}
    
    // Pas dans la fiche de présentation mais func rédigée au cas oû
    /*func addCandidate(firstName: String, lastName: String, email: String, token: String) {
        let newCandidate = Candidate(
            id: "", //nil ?
            firstName: firstName,
            lastName: lastName,
            email: email,
            isFavorite: false
        )
        isLoading = true
        APIService.shared.createCandidate(candidate: newCandidate, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let createdCandidate):
                    self?.candidates.append(createdCandidate)
                case .failure:
                    self?.errorMessage = "Erreur lors de l'ajout"
                }
            }
        }
    }*/

