import SwiftUI
import VitesseDomain

public struct RegisterView: View {
    
    @StateObject private var viewModel = RegisterViewModel()
    @State private var registrationSuccess = false
    
    public init() {}
    
    public var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Register")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                
                CandidateCase(title: "First Name") {
                    TextField("John", text: $viewModel.firstName)
                }
                
                CandidateCase(title: "Last Name") {
                    TextField("Doe", text: $viewModel.lastName)
                }
                
                CandidateCase(title: "Email") {
                    TextField("john.doe@gmail.com", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                CandidateCase(title: "Password") {
                    SecureField("", text: $viewModel.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                CandidateCase(title: "Confirm Password") {
                    SecureField("", text: $viewModel.confirmPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                
            }
            .padding(.bottom, 80)
            
            if let error = viewModel.registerErrorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.footnote)
            }
            Button("Create Account") {
                viewModel.signUp { success in
                    if success {
                        DispatchQueue.main.async {
                            registrationSuccess = true
                        }
                    }
                }
            }
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 70)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .disabled(viewModel.isLoading || !viewModel.passwordsMatch)
            
            
        }
        .padding(.horizontal, 24)
        .navigationDestination(isPresented: $registrationSuccess) {
            AuthenticationView()
        }
    }
}

#Preview {
    RegisterView()
}
