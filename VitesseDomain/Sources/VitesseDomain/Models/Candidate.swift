import Foundation

public struct Candidate: Identifiable, Codable, Sendable, Equatable {
    public let id: String
    public var firstName: String
    public var lastName: String
    public var email: String
    public var isFavorite: Bool
    public var phone: String?
    public var note: String?
    public var linkedInURL: String?

    public init(
        id: String,
        firstName: String,
        lastName: String,
        email: String,
        isFavorite: Bool,
        phone: String? = nil,
        note: String? = nil,
        linkedInURL: String? = nil
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.isFavorite = isFavorite
        self.phone = phone
        self.note = note
        self.linkedInURL = linkedInURL
    }
}
