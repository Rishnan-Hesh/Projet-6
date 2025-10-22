import SwiftUI
import VitesseDomain


//MARK: - Properties
public struct CandidatesView: View {
    @StateObject private var viewModel = CandidatesViewModel()
    @State private var selection = Set<UUID>()
    @State private var showFavoritesOnly = false
    @State private var isAdmin: Bool = true
    
    public init() {}

//MARK: - Body
    public var body: some View {
        VStack {
            HStack {
                Button(viewModel.isEditing ? "Done" : "Edit") {
                    viewModel.toggleEditMode()
                    if !viewModel.isEditing {
                        selection.removeAll()
                    }
                }
                Spacer()
                Text("Candidates")
                    .font(.headline)
                Spacer()
                if viewModel.isEditing {
                    Button("Delete") {
                        deleteSelected()
                    }
                    .disabled(selection.isEmpty)
                } else {
                    Button(action: {
                        showFavoritesOnly.toggle()
                    }) {
                        Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .scaleEffect(1.15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .frame(height: 44)
            
            TextField("Search", text: $viewModel.searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(filteredCandidates) { candidate in
                        NavigationLink(destination: CandidateDetailsView(
                            candidate: candidate,
                            onToggleFavorite: { updated in
                                viewModel.toggleFavorite(for: updated)
                            },
                        isAdmin: isAdmin)) {
                            HStack {
                                if viewModel.isEditing {
                                    Button(action: {
                                        toggleSelection(candidate)
                                    }) {
                                        Image(systemName: selection.contains(candidate.id) ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(selection.contains(candidate.id) ? .blue : .gray)
                                    }
                                }
                                Text(candidate.name)
                                Spacer()
                                Button(action: {
                                    if viewModel.isEditing {
                                        viewModel.toggleFavorite(for: candidate)
                                    }
                                }) {
                                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 1)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
            }
            .background(Color(.systemBackground))
        }
    }
    
//MARK: - FUNCS
    var filteredCandidates: [Candidate] {
        let candidates = showFavoritesOnly
            ? viewModel.filteredCandidates.filter { $0.isFavorite }
            : viewModel.filteredCandidates
        return candidates
    }
    
    func toggleSelection(_ candidate: Candidate) {
        if selection.contains(candidate.id) {
            selection.remove(candidate.id)
        } else {
            selection.insert(candidate.id)
        }
    }
    
    func deleteSelected() {
        viewModel.deleteCandidates(withIds: selection)
        selection.removeAll()
    }
}

#Preview {
    CandidatesView()
}
