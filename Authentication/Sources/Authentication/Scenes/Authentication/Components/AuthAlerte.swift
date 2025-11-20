public enum AlertType: Identifiable {
    case forgotPassword
    case loginError(String)

    public var id: Int {
        switch self {
        case .forgotPassword: return 0
        case .loginError: return 1
        }
    }

    var title: String { "Error" }

    var message: String {
        switch self {
        case .forgotPassword: return "Contact support"
        case .loginError(let message): return message
        }
    }
}
