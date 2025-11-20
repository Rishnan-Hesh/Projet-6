import SwiftUI
import VitesseDomain

public struct CandidatesView: View {

    @StateObject private var viewModel = CandidatesListViewModel()

    let token: String
    let isAdmin: Bool

    @State private var showDeleteAlert = false
    @State private var showAddCandidateForm = false

    public init(token: String, isAdmin: Bool) {
            self.token = token
            self.isAdmin = isAdmin
        }
    
    public var body: some View {
        VStack {
            headerBar
            searchBar
            if viewModel.isLoading { loader }
            candidatesList
            errorBanner
        }
        .sheet(isPresented: $showAddCandidateForm) {
            AddCandidateForm(viewModel: viewModel, token: token)
        }
        .onAppear {
            viewModel.loadCandidates(token: token)
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Confirm suppression"),
                message: Text("Delete selected candidates ?"),
                primaryButton: .destructive(Text("Delete")) {
                    viewModel.deleteCandidates(withIds: viewModel.selection, token: token)
                    viewModel.selection.removeAll()
                },
                secondaryButton: .cancel()
            )
        }
    }

    //MARK: - Header
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
                Button("Add") { showAddCandidateForm = true }
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
    }

    // SEARCHBAR
    private var searchBar: some View {
        TextField("Search", text: $viewModel.searchText)
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }

    // Loader central
    private var loader: some View {
        ProgressView("Loading...")
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

    //MARK: - Candidate Cell
    @ViewBuilder
    private func candidateCell(_ candidate: Candidate) -> some View {
        let isSelected = viewModel.selection.contains(candidate.id)
        let isFavorite = viewModel.isCandidateFavorite(candidate)

        let destinationView = CandidateDetailsView(
            candidate: candidate,
            onToggleFavorite: {
                viewModel.toggleFavoriteLocal(for: candidate)
            },
            onSave: { updated in
                viewModel.updateCandidate(updated, token: token)
            },
            isAdmin: isAdmin,
            isEditing: $viewModel.isEditing,
            isFavorite: isFavorite
        )

        let cellContent = HStack {
            if viewModel.isEditing {
                Button(action: { viewModel.toggleSelection(candidate) }) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(isSelected ? .blue : .gray)
                }
            }
            Text(candidate.firstName + " " + candidate.lastName)
            Spacer()
            Button(action: {
                if viewModel.isEditing {
                    viewModel.toggleFavoriteLocal(for: candidate)
                }
            }) {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .frame(maxWidth: 380)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        )

        NavigationLink(destination: destinationView) {
            cellContent
        }
    }

    //MARK: - Error Banner
    @ViewBuilder
    private var errorBanner: some View {
        if let error = viewModel.errorMessage {
            Text(error)
                .foregroundColor(.red)
                .padding()
        }
    }
}

