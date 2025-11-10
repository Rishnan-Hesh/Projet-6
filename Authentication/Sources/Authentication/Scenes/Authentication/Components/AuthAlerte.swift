public enum AlertType: Identifiable {
    case forgotPassword
    case loginError(String)

    public var id: Int {
        switch self {
        case .forgotPassword: return 0
        case .loginError: return 1
        }
    }

    var title: String { "Erreur" }

    var message: String {
        switch self {
        case .forgotPassword: return "Contactez le support"
        case .loginError(let message): return message
        }
    }
}
