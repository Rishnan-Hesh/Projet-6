import SwiftUI
import VitesseDomain

public struct CandidatesView: View {
    @StateObject private var viewModel = CandidatesViewModel()
    let token: String
    @State private var isAdmin: Bool = true
    @State private var showDeleteAlert = false

    public init(token: String) {
        self.token = token
    }

    public var body: some View {
        VStack {
            headerBar
            searchBar
            if viewModel.isLoading { loader }
            candidatesList
            errorBanner
        }
        .onAppear { viewModel.loadCandidates(token: token) }
    }

    // MARK: - HEADER
    private var headerBar: some View {
        HStack {
            Button(viewModel.isEditing ? "Done" : "Edit") {
                viewModel.toggleEditMode()
                if !viewModel.isEditing { viewModel.selection.removeAll() }
            }
            Spacer()
            Text("Candidates")
                .font(.headline)
            Spacer()
            if viewModel.isEditing {
                Button("Delete") { showDeleteAlert = true }
                    .disabled(viewModel.selection.isEmpty)
            } else {
                Button(action: { viewModel.showFavoritesOnly.toggle() }) {
                    Image(systemName: viewModel.showFavoritesOnly ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .scaleEffect(1.15)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal)
        .frame(height: 44)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Confirmer la suppression"),
                message: Text("Voulez-vous vraiment supprimer les candidats sélectionnés ?"),
                primaryButton: .destructive(Text("Supprimer")) {
                    viewModel.deleteCandidates(withIds: viewModel.selection, token: token)
                    viewModel.selection.removeAll()
                },
                secondaryButton: .cancel()
            )
        }
    }

    // MARK: - SEARCHBAR
    private var searchBar: some View {
        TextField("Search", text: $viewModel.searchText)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }

    // Loader central
    private var loader: some View {
        ProgressView("Chargement...")
            .padding()
    }

    // Liste des candidats
    private var candidatesList: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(viewModel.filteredCandidates) { candidate in
                    candidateCell(candidate)
                }
            }
        }
        .background(Color(.systemBackground))
    }

    // Cellule candidat
    @ViewBuilder
    private func candidateCell(_ candidate: Candidate) -> some View {
        NavigationLink(
            destination: CandidateDetailsView(
                candidate: candidate,
                onToggleFavorite: { updated in
                    viewModel.toggleFavorite(for: updated, token: token)
                },
                onSave: { updated in
                            viewModel.updateCandidate(updated, token: token)
                },
                isAdmin: isAdmin
            )
        ) {
            HStack {
                if viewModel.isEditing {
                    Button(action: { viewModel.toggleSelection(candidate) }) {
                        Image(systemName: viewModel.selection.contains(candidate.id) ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(viewModel.selection.contains(candidate.id) ? .blue : .gray)
                    }
                }
                Text(candidate.firstName + " " + candidate.lastName)
                Spacer()
                Button(action: {
                    if viewModel.isEditing {
                        viewModel.toggleFavorite(for: candidate, token: token)
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            )
        }
    }

    // Bandeau d'erreur
    @ViewBuilder
    private var errorBanner: some View {
        if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .padding()
        }
    }
}
