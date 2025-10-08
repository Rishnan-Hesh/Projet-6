import SwiftUI
import VitesseDomain

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

struct RegisterView: View {
    
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Register")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                    .padding(.bottom, 50)
                
                CustomCase(title: "First Name") {
                    TextField("John", text: $viewModel.firstName)
                }
                
                CustomCase(title: "Last Name") {
                    TextField("Doe", text: $viewModel.lastName)
                }
                
                CustomCase(title: "Email") {
                    TextField("john.doe@gmail.com", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                CustomCase(title: "Password") {
                    SecureField("", text: $viewModel.password)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                CustomCase(title: "Confirm Password") {
                    SecureField("", text: $viewModel.confirmPassword)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                
            }
            .padding(.bottom, 80) // Logique pour avoir le meme password
            
            
            NavigationLink(destination: AuthenticationView()) { // Destination a renseigner dans l'app
                
                
                // Send/save data
                Text("Create")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray4))
                    .foregroundColor(.black)
                    .cornerRadius(8)
            }
            .padding(.top, 12)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    RegisterView()
}


/*.onTapGesture {
 self.endEditing(true)  // Dismiss keyboard when tapping outside
 }*/
