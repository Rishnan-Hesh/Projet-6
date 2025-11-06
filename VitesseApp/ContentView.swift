import SwiftUI
import Authentication
import Candidates
import VitesseDomain
import VitesseData

struct ContentView: View {
    @State private var openCandidates = false
    @State private var openRegister = false

    var body: some View {
        NavigationStack {
            AuthenticationView()
            .navigationDestination(isPresented: $openCandidates) {
                CandidatesView(token: "")
            }
            .navigationDestination(isPresented: $openRegister) {
                RegisterView()
            }
        }
    }
}

#Preview {
    ContentView()
}
