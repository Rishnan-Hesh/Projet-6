import SwiftUI
import VitesseDomain

public struct CandidatesView: View {
    @State private var searchText: String = ""
    @State private var candidates: [Candidate] = [
        Candidate(name: "Jean Pierre P.", isFavorite: true),
        Candidate(name: "Jean Michel P.", isFavorite: false),
        Candidate(name: "Jean Pierre A.", isFavorite: true),
        Candidate(name: "Jean Michel Z.", isFavorite: false),
        Candidate(name: "Jean Pierre B.", isFavorite: true),
        Candidate(name: "Jean Michel M.", isFavorite: false),
        Candidate(name: "Jean Pierre P.", isFavorite: true),
        Candidate(name: "Jean Michel P.", isFavorite: false),
        Candidate(name: "Jean Pierre A.", isFavorite: true),
        Candidate(name: "Jean Michel Z.", isFavorite: false),
        Candidate(name: "Jean Pierre B.", isFavorite: true),
        Candidate(name: "Jean Michel M.", isFavorite: false)
    ]
    
    public init() {}
    
    
    var filteredCandidates: [Candidate] {
        if searchText.isEmpty {
            return candidates
        } else {
            return candidates.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
        }
    }
    public var body: some View {
        VStack {
            HStack {
                Button("Edit") { /* action ici */ }
                Spacer()
                Text("Candidates")
                    .font(.headline)
                Spacer()
                Image(systemName: "star")
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal)
            .frame(height: 44)
            
            TextField("Search", text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            

            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(filteredCandidates) { candidate in
                        NavigationLink(destination: CandidateDetailsView(candidate: candidate)) {
                            HStack {
                                Text(candidate.name)
                                Spacer()
                                Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            .padding()
                            .frame(maxWidth: .infinity) // prend toute la largeur dispo
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color(.separator), lineWidth: 1)
                                    )
                            )
                            .padding(.horizontal, 15) // espacement cotés des cases
                        }
                    }
                }
                .padding(.top, 15)
            }
            .background(Color(.systemBackground)) // Fond blanc sous la scrollview
        }
        .background(Color(.systemBackground)) // Fond blanc global
    }
}


#Preview {
    CandidatesView()
}
