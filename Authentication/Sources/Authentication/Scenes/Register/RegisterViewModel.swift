import SwiftUI
import Combine
import VitesseDomain
import VitesseData

@MainActor
final class RegisterViewModel: ObservableObject, @unchecked Sendable {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var confirmPassword: String = ""
    @Published var isLoading: Bool = false
    @Published var registerErrorMessage: String? = nil
    
    // MARK: - Register
    func signUp(completion: @escaping @Sendable (Bool) -> Void) {
        registerErrorMessage = nil
        isLoading = true
        
        let registerRequest = RegisterRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        APIService.shared.registerUser(request: registerRequest) { [weak self] result in
            Task { @MainActor in
                self?.isLoading = false
                switch result {
                case .success:
                    completion(true)
                case .failure:
                    self?.registerErrorMessage = "Erreur lors de la création du compte"
                    completion(false)
                }
            }
        }
    }
    
    // MARK: - Password similaires
    var passwordsMatch: Bool {
        return password == confirmPassword && !password.isEmpty
    }
}
