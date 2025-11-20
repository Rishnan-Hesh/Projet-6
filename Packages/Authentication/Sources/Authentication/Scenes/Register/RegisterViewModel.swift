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
    
    private let registerUserClosure: (RegisterRequest, @escaping (Result<Void, Error>) -> Void) -> Void
    
    // L'init standard pour la prod
    init(apiService: APIService = .shared) {
        self.registerUserClosure = apiService.registerUser
    }
    
    // Init pour les tests/mock
    init(registerUserClosure: @escaping (RegisterRequest, @escaping (Result<Void, Error>) -> Void) -> Void) {
        self.registerUserClosure = registerUserClosure
    }
    
    //MARK: - SIGNUP
    func signUp(completion: @escaping (Bool) -> Void) {
        registerErrorMessage = nil
        isLoading = true
        
        let registerRequest = RegisterRequest(email: email, password: password, firstName: firstName, lastName: lastName)
        registerUserClosure(registerRequest) { [weak self] result in
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
    
    //MARK: - PASSWORD
    var passwordsMatch: Bool {
        return password == confirmPassword && !password.isEmpty
    }
}
