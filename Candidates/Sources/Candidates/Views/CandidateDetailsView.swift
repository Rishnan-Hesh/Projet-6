import SwiftUI
import VitesseDomain

struct CandidateDetailsView: View {
    var candidate: Candidate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            headerPart
            
            contactInfoPart
            
            linkedInPart
            
            notePart
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    // action ici
                }
            }
        }
    }
    
    private var headerPart: some View {
        HStack {
            Text(candidate.name)
                .font(.title2)
                .fontWeight(.medium)
            Spacer()
            Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                .foregroundColor(.yellow)
                .font(.title2)
        }
    }
    
    private var contactInfoPart: some View {
        VStack(alignment: .leading, spacing: 8) {
            infoItemsPart(title: "Phone", value: "09 12 12 32 32")
            infoItemsPart(title: "Email", value: "jeanmichelp@toto.com")
        }
    }
    
    private func infoItemsPart(title: String, value: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
    
    private var linkedInPart: some View {
        HStack {
            Text("LinkedIn")
                .font(.caption)
            Spacer()
            Button("Go on LinkedIn") {
                // action
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(6)
            .padding(.horizontal, 90)
        }
    }
    
    private var notePart: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Note")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 30)
            
            Text("Penser à acheter des tomates et des herbes aromatiques.")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.07), radius: 1, x: 0, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                )
                .font(.body)
        }
    }
}




#Preview {
    CandidateDetailsView(candidate: Candidate(
        name: "Jean Michel",
        isFavorite: true
    ))
}

