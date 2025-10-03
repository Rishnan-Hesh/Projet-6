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

struct RegisterView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Register")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 40)
                    .padding(.bottom, 50)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("First Name")
                        .font(.headline)
                    TextField("John", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                    
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Last Name")
                        .font(.headline)
                    TextField("Doe", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.headline)
                    TextField("John.Doe@gmail.com", text: $email)
                        .keyboardType(.emailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Password")
                        .font(.headline)
                    SecureField("", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("Confirm Password")
                        .font(.headline)
                    SecureField("", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary, lineWidth: 0.5)
                        )
                }
                .padding(.bottom, 80) // Logique pour avoir le meme password
                
                
                NavigationLink(destination: AuthenticationViews()) { // Destination a renseigner dans l'app
                    
                
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
}
            
#Preview {
    RegisterView()
}
            
            
            /*.onTapGesture {
             self.endEditing(true)  // Dismiss keyboard when tapping outside
             }*/


@available(iOS 15.0, *)
struct AuthenticationViews: View {
    var body: some View {
        Text("Temporaire AuthenticationViews")
    }
}

/*private func customCase(title:String, content:() -> some View) -> some View {
    
}

struct CustomCase: some View {
    
    private let title: String
    private let content: () -> some View
    
    var body: some View {
        VStack(alignment: .leading,spacing: 6) {
            Text(title)
            .font(.headline})
        
        content()
            .TextFieldStyle(RoundedBorderTextFieldStyle())
            .overlay(RoundedRectangle(cornerRadius: PresentationConstants.Paddings.regular)
                .stroke(Color.primary, linewidth: 0.5)
                     )
        }
    }*/
