import SwiftUI


/*Écran de connexion
● Permettre à l'utilisateur de se connecter en utilisant son e-mail et son mot de
passe.
Éléments UI
● Champs de texte pour :
○ E-mail
○ Mot de passe
● Bouton 'Sign in'
● Bouton 'Register' pour naviguer vers l'écran d'inscription
Actions
● Après avoir entré les informations et cliqué sur 'Sign in'
, l'application doit valider
les informations et connecter l'utilisateur.
● Le clic sur le bouton ‘Register’ doit rediriger l’utilisateur vers la vue de création de
compte*/

@available(iOS 14.0, *)
struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 28) {
            Spacer(minLength: 40)
            
            // Title
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 16)
            
            // Conexion
            VStack(alignment: .leading, spacing: 12) {
                Text("Email/Username")
                    .font(.headline)
                TextField("test@mail.com", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                Text("Password")
                    .font(.headline)
                SecureField("Mot de passe", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    // logic
                }) {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4)
                
                if let error = viewModel.loginErrorMessage {
                    Text("Connexion Failed")
                        .foregroundColor(.red)
                        .font(.footnote)
                }
            }
            .padding(.horizontal, 8)
            
            // Actions
            VStack(spacing: 16) {
                Button(action: {
                    // To CandidatsView
                }) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primary.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // To RegisterView
                }) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primary, lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 8)
            
            Spacer(minLength: 40)
        }
        .padding(.horizontal, 40)
    }
}
    

    /*.onTapGesture {
        self.endEditing(true)  // Dismiss keyboard when tapping outside
    }*/

/*#Preview {
    LoginView(viewModel: LoginViewModel(onLoginSucceed: { }))
}*/
