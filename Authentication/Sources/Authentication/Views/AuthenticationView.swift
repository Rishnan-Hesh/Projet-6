import SwiftUI
import VitesseDomain
import Candidates

public struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @State private var showError = false
    
    @State private var isShowingRegister = false
    @State private var isLoggedIn = false

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

                    Button(action: { showError = true }) {
                        Text("Forgot password?")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 6)
                    .alert(isPresented: $showError) {
                        Alert(
                            title: Text("Erreur"),
                            message: Text("Contactez le support"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }
                .padding(.horizontal, 24)

                Spacer(minLength: 20)

                VStack(spacing: 18) {
                    AuthenticationButton(title: "Sign in", action: {
                        // Ajoutez ici votre logique de validation
                        // Puis déclenchez la navigation vers CandidatesView
                        isLoggedIn = true
                    })
                    .frame(maxWidth: .infinity)

                    AuthenticationButton(title: "Register", action: {
                        isShowingRegister = true
                    })
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 60)

                // NavigationLinks cachés déclenchés par état boolean
                NavigationLink(destination: RegisterView(), isActive: $isShowingRegister) {
                    EmptyView()
                }
                NavigationLink(destination: CandidatesView(token: <#String#>), isActive: $isLoggedIn) {
                    EmptyView()
                }
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
    }

/*.onTapGesture {
 self.endEditing(true)  // Dismiss keyboard when tapping outside
 }*/


#Preview {
    AuthenticationView()
}
