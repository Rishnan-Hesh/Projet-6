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
