import SwiftUI

struct Candidate: Identifiable {
    let id: UUID = UUID()
       let name: String
       var isFavorite: Bool
       var phone: String?
       var email: String?
       var linkedInURL: String?
       var note: String?
}

struct CandidatesView: View {
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
    
    var filteredCandidates: [Candidate] {
        if searchText.isEmpty {
            return candidates
        } else {
            return candidates.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            
        }
    }
    
    var body: some View {
        NavigationView {
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
                
                List(filteredCandidates) { candidate in
                    HStack {
                        Text(candidate.name)
                        Spacer()
                        Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.08), radius: 40, x: 0, y: 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets()) // Pour enlever l’offset par défaut
                    .padding(.vertical, 5)// Espacement entre les cases
                    .padding(.horizontal, 5)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    CandidatesView()
}
