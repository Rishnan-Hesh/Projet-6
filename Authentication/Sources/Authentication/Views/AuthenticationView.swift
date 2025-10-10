import SwiftUI
import VitesseDomain
import Candidates

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
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
                Button(action: { /* action mot de passe oublié */ }) {
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
                Button(action: { /* logique connexion */ }) {
                    Text("Sign in")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 80)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
                
                
                Button(action: { /* navigation inscription */ }) {
                    Text("Register")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 74)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
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
    AuthenticationView()
}


