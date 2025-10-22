import SwiftUI
import VitesseDomain

@MainActor
final class CandidatesViewModel: ObservableObject {
    @Published var candidates: [Candidate] = [
        Candidate(name: "Pierre P.", isFavorite: true),
        Candidate(name: "Michel H.", isFavorite: false),
        Candidate(name: "Baptiste A.", isFavorite: true),
        Candidate(name: "Aymerik Z.", isFavorite: false),
        Candidate(name: "Miguel B.", isFavorite: true),
        Candidate(name: "Serge M.", isFavorite: false)
    ]
    
    @Published var isEditing: Bool = false
    @Published var searchText: String = ""
    
    var filteredCandidates: [Candidate] {
        if searchText.isEmpty {
            return candidates
        } else {
            return candidates.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func toggleEditMode() {
        isEditing.toggle()
    }
    
    func deleteCandidate(at index: IndexSet) {
        candidates.remove(atOffsets: index)
    }
    
    func deleteCandidates(withIds ids: Set<UUID>) {
        candidates.removeAll { candidate in
            ids.contains(candidate.id)
        }
    }
    
    func updateCandidate(_ candidate: Candidate, newName: String) {
        if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
            candidates[index].name = newName
        }
    }
    
    func toggleFavorite(for candidate: Candidate) {
        if let index = candidates.firstIndex(where: { $0.id == candidate.id }) {
            candidates[index].isFavorite.toggle()
        }
    }
    
    func addCandidate() {
        let newCandidate = Candidate(name: "Nouveau candidat", isFavorite: false)
        candidates.append(newCandidate)
    }
}

