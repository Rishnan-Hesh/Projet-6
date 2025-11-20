public struct AuthResponse: Codable {
    public let token: String
    public let isAdmin: Bool
    
    public init(token: String, isAdmin: Bool) {
            self.token = token
            self.isAdmin = isAdmin
        }
    }
