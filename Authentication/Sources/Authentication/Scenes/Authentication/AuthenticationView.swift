import SwiftUI
import VitesseDomain
import Candidates

public struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    @State private var isShowingRegister = false
    @State private var alertType: AlertType? = nil
    
    public init() {}
    
    
    public var body: some View {
        NavigationStack {
            VStack {
                Spacer(minLength: 40)
                
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 100)
                
                VStack(alignment: .leading, spacing: 14) {
                    Text("Email/Username")
                        .font(.headline)
                    
                    TextField("test@mail.com", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Text("Password")
                        .font(.headline)
                        .padding(.top, 10)
                    
                    SecureField("•••••••••••••", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Button(action: {
                        print("Forgot password tapped")
                        alertType = .forgotPassword
                    }) {
                        Text("Forgot password ?")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 6)
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 20)
                
                VStack(spacing: 18) {
                    AuthenticationButton(title: "Sign in") {
                        viewModel.signIn()
                    }
                    .frame(maxWidth: .infinity)
                    
                    AuthenticationButton(title: "Register") {
                        isShowingRegister = true
                    }
                    .frame(maxWidth: .infinity)
                    
                    if let errorMessage = viewModel.loginErrorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)
                
                
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .alert(item: $alertType) { alert in
                Alert(
                    title: Text(alert.title),
                    message: Text(alert.message),
                    dismissButton: .default(Text("OK")) {
                        alertType = nil
                    }
                )
            }
            .navigationDestination(isPresented: $isShowingRegister) {
                RegisterView()
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.token != nil },
                set: { isActive in if !isActive { viewModel.token = nil } }
            )) {
                CandidatesView(token: viewModel.token ?? "", isAdmin: viewModel.isAdmin)
            }
        }
    }
}


#Preview {
    AuthenticationView()
}
