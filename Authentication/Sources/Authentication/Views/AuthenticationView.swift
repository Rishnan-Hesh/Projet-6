import SwiftUI
import VitesseDomain
import Candidates

public struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
        var SignInAction: (() -> Void)? = nil
        var RegisterAction: (() -> Void)? = nil
        /*var ForgotPasswordAction: (() -> Void)? = nil*/
    
    public init(
        SignInAction: (() -> Void)? = nil,
        RegisterAction: (() -> Void)? = nil
    ) {
        self.SignInAction = SignInAction
        self.RegisterAction = RegisterAction
    }
    
    public var body: some View {
        VStack {
            Spacer(minLength: 40)
            
            //Champs à remplir
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 100)
            
            VStack(alignment: .leading, spacing: 6) {
                
                Text("Email/Username")
                    .font(.headline)
                TextField("test@mail.com", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primary, lineWidth: 0.5))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Text("Password")
                    .font(.headline)
                    .padding(.top, 10)
                SecureField("•••••••••••••", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primary, lineWidth: 0.5))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                // Forgot password
                Button(action: { /* ForgotPasswordAction?() */ }) {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 175)
            
            //Sign in and register
            VStack(spacing: 18) {
                AuthenticationButton(title: "Sign in", action: { SignInAction?() })
                AuthenticationButton(title: "Register", action: { RegisterAction?() })
            }

            Spacer(minLength: 40)
        }
        .background(Color.white)
    }
}


/*.onTapGesture {
 self.endEditing(true)  // Dismiss keyboard when tapping outside
 }*/


#Preview {
    AuthenticationView(
        SignInAction: { print("Sign in tapped") },
        RegisterAction: { print("Register tapped") }
    )
}


