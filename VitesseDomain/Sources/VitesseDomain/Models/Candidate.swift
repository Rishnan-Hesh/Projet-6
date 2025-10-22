import SwiftUI
import Foundation

public struct Candidate: Identifiable {
    public let id: UUID = UUID()
    public var name: String
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
