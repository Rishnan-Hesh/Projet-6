import SwiftUI
import VitesseDomain
import VitesseData

@MainActor
protocol CandidateServiceProtocol {
    func createCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    )
    func fetchCandidates(
        token: String,
        completion: @escaping @Sendable (Result<[Candidate], Error>) -> Void
    )
    func deleteCandidate(
        candidateId: String,
        token: String,
        completion: @escaping @Sendable (Result<Void, Error>) -> Void
    )
    func updateCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    )
}


// pour utiliser le vrai service en prod
extension APIService: CandidateServiceProtocol {}

//mock pour tester en injection dans le ViewModel
final class MockCandidateService: CandidateServiceProtocol {

    func createCandidate(candidate: Candidate, token: String, completion: @escaping (Result<Candidate, Error>) -> Void) { }
    func fetchCandidates(token: String, completion: @escaping (Result<[Candidate], Error>) -> Void) { }
    func deleteCandidate(candidateId: String, token: String, completion: @escaping (Result<Void, Error>) -> Void) { }
    func updateCandidate(candidate: Candidate, token: String, completion: @escaping (Result<Candidate, Error>) -> Void) { }
}

@MainActor
final class CandidatesListViewModel: ObservableObject {
    @Published var candidates: [Candidate] = []
    @Published var localFavorites: Set<String> = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var isEditing: Bool = false
    @Published var searchText: String = ""
    @Published var showFavoritesOnly: Bool = false
    @Published var selection = Set<String>()
    @Published var isCreatingCandidate: Bool = false
    @Published var createCandidateErrorMessage: String? = nil

    @Published var candidateEmail: String = ""
    @Published var candidateNote: String? = nil
    @Published var candidateLinkedinURL: String? = nil
    @Published var candidateFirstName: String = ""
    @Published var candidateLastName: String = ""
    @Published var candidatePhone: String = ""
    
    private let service: CandidateServiceProtocol

    init(service: CandidateServiceProtocol = APIService.shared) {
        self.service = service
    }
    
    // MARK: - CREATE
    func createCandidate(token: String) {
        isCreatingCandidate = true
        createCandidateErrorMessage = nil
        
        let newCandidate = Candidate(
            id: UUID().uuidString,
            firstName: candidateFirstName,
            lastName: candidateLastName,
            email: candidateEmail,
            phone: candidatePhone,
            note: candidateNote,
            linkedInURL: candidateLinkedinURL
        )

        service.createCandidate(candidate: newCandidate, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isCreatingCandidate = false
                switch result {
                case .success(let createdCandidate):
                    self?.candidates.append(createdCandidate)
                    self?.candidateEmail = ""
                    self?.candidateNote = nil
                    self?.candidateLinkedinURL = nil
                    self?.candidateFirstName = ""
                    self?.candidateLastName = ""
                    self?.candidatePhone = ""
                case .failure(let error):
                    self?.createCandidateErrorMessage = "Erreur : \(error.localizedDescription)"
                }
            }
        }
    }
    
    // MARK: - FILTER
    var filteredCandidates: [Candidate] {
        var filtered = candidates
        if showFavoritesOnly {
            filtered = filtered.filter { localFavorites.contains($0.id) }
        }
        if !searchText.isEmpty {
            let search = searchText.lowercased()
            filtered = filtered.filter {
                $0.firstName.lowercased().contains(search) ||
                $0.lastName.lowercased().contains(search) ||
                ("\($0.firstName) \($0.lastName)").lowercased().contains(search) ||
                ("\($0.lastName) \($0.firstName)").lowercased().contains(search)
            }
        }
        return filtered
    }

    func toggleEditMode() {
        isEditing.toggle()
    }

    func isCandidateFavorite(_ candidate: Candidate) -> Bool {
        localFavorites.contains(candidate.id)
    }
    
    func toggleFavoriteLocal(for candidate: Candidate) {
        if localFavorites.contains(candidate.id) {
            localFavorites.remove(candidate.id)
        } else {
            localFavorites.insert(candidate.id)
        }
    }
    
    // MARK: - LOAD
    func loadCandidates(token: String) {
        isLoading = true
        errorMessage = nil
        service.fetchCandidates(token: token) { [weak self] result in
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

    // MARK: - DELETE
    func deleteCandidates(withIds ids: Set<String>, token: String) {
        isLoading = true
        errorMessage = nil
        let group = DispatchGroup()
        let failedIdsStore = FailedIdsStore()

        for id in ids {
            group.enter()
            service.deleteCandidate(candidateId: id, token: token) { [weak self] result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        self?.candidates.removeAll { $0.id == id }
                    }
                case .failure:
                    Task {
                        await failedIdsStore.append(id)
                    }
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            Task {
                let failedIds = await failedIdsStore.getAll()
                self?.isLoading = false
                if !failedIds.isEmpty {
                    self?.errorMessage = "Erreur lors de la suppression de certains candidats"
                }
            }
        }
    }

    func deleteCandidate(withId id: String, token: String) {
        deleteCandidates(withIds: [id], token: token)
    }
    
    // MARK: - UPDATE
    func updateCandidate(_ candidate: Candidate, token: String) {
        isLoading = true
        errorMessage = nil
        service.updateCandidate(candidate: candidate, token: token) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let updatedCandidate):
                    if let index = self?.candidates.firstIndex(where: { $0.id == updatedCandidate.id }) {
                        self?.candidates[index] = updatedCandidate
                    }
                case .failure:
                    self?.errorMessage = "Erreur lors de la mise à jour du candidat"
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

    actor FailedIdsStore {
        private var failedIds: [String] = []
        func append(_ id: String) {
            failedIds.append(id)
        }
        func getAll() -> [String] {
            failedIds
        }
    }
}

