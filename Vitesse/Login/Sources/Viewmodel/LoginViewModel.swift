import SwiftUI
import Combine

@available(iOS 13.0, *)
class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    
    
    @Published var isLoginEnabled: Bool = false
    @Published var loginErrorMessage: String? = nil
    @Published var isLoading: Bool = false
        
    func signIn() {
        
        loginErrorMessage = nil
        isLoading = true
        
    }
    
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let pred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return pred.evaluate(with: email)
    }
}

