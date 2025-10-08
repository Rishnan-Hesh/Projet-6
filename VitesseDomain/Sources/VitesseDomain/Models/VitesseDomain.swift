import SwiftUI
import Foundation

public struct CustomCase<Content: View>: View {
    let title: String
    let content: Content
    
    public init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.headline)
            content
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.primary, lineWidth: 0.5)
                )
        }
    }
}

public struct Candidate: Identifiable {
    public let id: UUID = UUID()
    public let name: String
    public var isFavorite: Bool
    public var phone: String?
    public var email: String?
    public var linkedInURL: String?
    public var note: String?
    
    public init(name: String, isFavorite: Bool, phone: String? = nil, email: String? = nil, linkedInURL: String? = nil, note: String? = nil) {
        self.name = name
        self.isFavorite = isFavorite
        self.phone = phone
        self.email = email
        self.linkedInURL = linkedInURL
        self.note = note
    }
}
