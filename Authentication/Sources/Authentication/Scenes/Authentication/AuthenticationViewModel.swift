import SwiftUI
import Combine
import VitesseDomain
import VitesseData

final class AuthenticationViewModel: ObservableObject, @unchecked Sendable{
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var isLoginEnabled: Bool = false
    @Published var loginErrorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var token: String? = nil  // Stockage du toekn

    // MARK: Sign-In, loading, errors and save token
    @MainActor func signIn() {
        loginErrorMessage = nil
        isLoading = true
        
        APIService.shared.authenticate(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                let token = response.token
                Task { @MainActor in
                    self?.isLoading = false
                    self?.token = token
                }
            case .failure:
                Task { @MainActor in
                    self?.isLoading = false
                    self?.loginErrorMessage = "Identifiants incorrects ou erreur réseau"
                }
            }
        }
    }
    
    // MARK: - Register
    @MainActor func signUp() {
        loginErrorMessage = nil
        isLoading = true
        let registerRequest = RegisterRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        
        APIService.shared.registerUser(request: registerRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    self?.signIn()
                    
                case .failure:
                    self?.loginErrorMessage = "Erreur lors de la création du compte"
                }
            }
        }
    }
    
    // MARK: - Email Regex
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return pred.evaluate(with: email)
    }
}
