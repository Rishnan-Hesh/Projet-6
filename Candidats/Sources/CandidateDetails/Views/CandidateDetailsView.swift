import SwiftUI

struct CandidateDetailsView: View {
    var candidate: Candidate
    
    var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                
                HStack {
                    Button {
                        // action retour
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                    }
                    Spacer()
                    Button("Edit") { /* Action ici */ }
                        .font(.subheadline)
                }
                
                HStack {
                    Text(candidate.name)
                        .font(.title2)
                        .fontWeight(.medium)
                    Spacer()
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title2)
                }
                
                
                Group {
                    Text("Phone")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("09 12 12 32 32")
                        .font(.body)
                    Text("Email")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("jeanmichelp@toto.com")
                        .font(.body)
                }
                
                // LinkedIn
                HStack {
                    Text("LinkedIn")
                        .font(.caption)
                    Spacer()
                    Button("Go on LinkedIn") {
                        //action
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal, 90)
                }
                
                Text("Note")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 30)
                
                Text("Penser à acheter des tomates et des herbes aromatiques.")
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color.black.opacity(0.07), radius: 1, x: 0, y: 1)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(.separator), lineWidth: 1)
                            )
                    )
                    .font(.body)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }

#Preview {
    CandidateDetailsView(candidate: Candidate(
        name: "Jean Michel P.",
        isFavorite: true,
        phone: "09 12 12 32 32",
        email: "jeanmichelp@toto.com",
        linkedInURL: "https://linkedin.com/in/jeanmichelp",
        note: "Penser à acheter des tomates et des herbes aromatiques."
    ))
}
