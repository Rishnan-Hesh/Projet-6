import SwiftUI
import Combine
import VitesseDomain
import VitesseData

//MARK: - Properties
@MainActor
public protocol AuthenticationServiceProtocol {
    func authenticate(
        email: String,
        password: String,
        completion: @escaping @Sendable (Result<AuthResponse, Error>) -> Void
    )
}

extension APIService: AuthenticationServiceProtocol {}

@MainActor
final class AuthenticationViewModel: ObservableObject, @unchecked Sendable {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginEnabled: Bool = false
    @Published var loginErrorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var token: String? = nil
    @Published var isForgotPasswordError: Bool = false
    @Published var isAdmin: Bool = false
    
    private let apiService: AuthenticationServiceProtocol
    
    init(apiService: AuthenticationServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    // MARK: - SignIn
    func signIn() {
        loginErrorMessage = nil
        isLoading = true
        apiService.authenticate(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                let token = response.token
                let isAdmin = response.isAdmin
                Task { @MainActor in
                    self?.token = token
                    self?.isLoading = false
                    self?.isAdmin = isAdmin
                }
            case .failure:
                Task { @MainActor in
                    self?.loginErrorMessage = "Wrong ID or Nertwork error"
                    self?.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Forgot Password
    func forgotPassword() {
        isForgotPasswordError = true
    }
    
    func resetErrors() {
        loginErrorMessage = nil
        isForgotPasswordError = false
    }
    
    // MARK: - Email valide
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return pred.evaluate(with: email)
    }
}
