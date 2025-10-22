import SwiftUI
import VitesseDomain

//MARK: - Properties
public struct CandidateDetailsView: View {
    @State private var phone: String = "09 12 12 32 32"
    @State private var email: String = "jeanmichelp@toto.com"
    @State private var note: String = "Penser à acheter des tomates et des herbes aromatiques."
    @State private var linkedInUrl: String = "https://www.linkedin.com/"
    @State private var other: String = ""
    @State private var isEditing: Bool = false
    
    public var onToggleFavorite: ((Candidate) -> Void)?
    public var candidate: Candidate
    public var isAdmin: Bool
    
    public init(candidate: Candidate, onToggleFavorite: ((Candidate) -> Void)? = nil, isAdmin: Bool = false) {
        self.candidate = candidate
        self.onToggleFavorite = onToggleFavorite
        self.isAdmin = isAdmin
    }
    
    
    
    //MARK: - Body
    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(candidate.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    if isEditing && isAdmin {
                        var updated = candidate
                        updated.isFavorite.toggle()
                        onToggleFavorite?(updated)
                    }
                }) {
                    Image(systemName: candidate.isFavorite ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.yellow)
                        .opacity(isEditing ? 1 : 0.5)
                }
                .buttonStyle(PlainButtonStyle())
                .disabled(!isEditing)
            }
            .padding(.bottom, 10)
            
            
            VStack(alignment: .leading, spacing: 8) {
                if isEditing {
                    TextField("Téléphone", text: $phone)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                    TextField("Email", text: $email)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                } else {
                    infoItemsPart(title: "Phone", value: phone)
                    infoItemsPart(title: "Email", value: email)
                }
            }
            
            // MARK: - LinkedIn
            HStack {
                Text("LinkedIn")
                    .font(.caption)
                Spacer()
                if isEditing {
                    TextField("URL LinkedIn", text: $linkedInUrl)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                        .padding(.horizontal, 90)
                } else {
                    Button("Go on LinkedIn") {
                        if let url = URL(string: linkedInUrl) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal, 90)
                }
            }
            
            // MARK: - Note
            VStack(alignment: .leading, spacing: 4) {
                Text("Note")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.top, 30)
                if isEditing {
                    TextField("Note", text: $note)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                } else {
                    Text(note)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.07), radius: 1, x: 0, y: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
            
            if isEditing {
                TextField("Other", text: $other)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    )
            } else {
                infoItemsPart(title: "Other", value: other)
            }
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }
}

#Preview("Candidate Details") {
    CandidateDetailsView(
        candidate: Candidate(
            name: "Jean Michel",
            isFavorite: true
        ),
        onToggleFavorite: { _ in },
        isAdmin: true
    )
}
