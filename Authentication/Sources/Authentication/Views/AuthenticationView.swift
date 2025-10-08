import SwiftUI
import VitesseDomain
import CandidatesPCK

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

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        VStack {
            Spacer(minLength: 40)
            // Titre centré
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 100)
            
            // Champs du formulaire
            VStack(alignment: .leading, spacing: 6) {
                // Email
                Text("Email/Username")
                    .font(.headline)
                TextField("test@mail.com", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primary, lineWidth: 0.5))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
    
                // Password
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
                
                // Mot de passe oublié
                Button(action: { /* action mot de passe oublié */ }) {
                    Text("Forgot password?")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }
                .padding(.top, 4) // tout petit espace
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 175)
            
            // Boutons actions
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


