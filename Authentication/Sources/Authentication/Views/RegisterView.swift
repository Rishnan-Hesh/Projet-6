import SwiftUI
import VitesseDomain

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
            .padding(.bottom, 80) // Logique pour avoir le meme password a ajouter ?
            
            
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
