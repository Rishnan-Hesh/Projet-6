import SwiftUI
import VitesseDomain

public struct CandidateDetailsView: View {
    @State private var firstName: String
    @State private var lastName: String
    @State private var email: String
    @State private var phone: String
    @State private var note: String
    @State private var linkedInURL: String
    @State private var isFavorite: Bool

    @Binding public var isEditing: Bool
    public var onToggleFavorite: (() -> Void)?
    public var onSave: ((Candidate) -> Void)?
    public var candidate: Candidate
    public var isAdmin: Bool

    public init(
        candidate: Candidate,
        onToggleFavorite: (() -> Void)? = nil,
        onSave: ((Candidate) -> Void)? = nil,
        isAdmin: Bool = false,
        isEditing: Binding<Bool>,
        isFavorite: Bool
    ) {
        self.candidate = candidate
        self.onToggleFavorite = onToggleFavorite
        self.onSave = onSave
        self.isAdmin = isAdmin
        self._isEditing = isEditing
        _firstName = State(initialValue: candidate.firstName)
        _lastName = State(initialValue: candidate.lastName)
        _email = State(initialValue: candidate.email)
        _phone = State(initialValue: candidate.phone ?? "")
        _note = State(initialValue: candidate.note ?? "")
        _linkedInURL = State(initialValue: candidate.linkedInURL ?? "")
        _isFavorite = State(initialValue: isFavorite)
    }

    // MARK: - BODY
    public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Text(firstName)
                    .font(.title2)
                    .fontWeight(.semibold)
                Spacer()
                Button(action: {
                    if isEditing && isAdmin {
                        isFavorite.toggle()
                        onToggleFavorite?()
                    }
                }) {
                    Image(systemName: isFavorite ? "star.fill" : "star")
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
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        )
                    TextField("Email", text: $email)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        )
                } else {
                    infoItemsPart(title: "Phone", value: phone)
                    infoItemsPart(title: "Email", value: email)
                }
            }

            HStack {
                Text("LinkedIn")
                    .font(.caption)
                Spacer()
                if isEditing {
                    TextField("URL LinkedIn", text: $linkedInURL)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.systemBackground))
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        )
                        .padding(.horizontal, 90)
                } else {
                    Button("Go on LinkedIn") {
                        if let url = URL(string: linkedInURL) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .padding(.horizontal, 90)
                }
            }

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
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        )
                } else {
                    Text(note)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color(.systemBackground))
                                .shadow(color: Color.black.opacity(0.07), radius: 1, x: 0, y: 1)
                                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        )
                }
            }

            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditing ? "Enregistrer" : "Modifier") {
                    if isEditing {
                        var updated = candidate
                        updated.firstName = firstName
                        updated.lastName = lastName
                        updated.email = email
                        updated.phone = phone
                        updated.note = note
                        updated.linkedInURL = linkedInURL
                        onSave?(updated)
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}
