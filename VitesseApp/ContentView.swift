import SwiftUI
import Authentication
import Candidates
import VitesseDomain

struct ContentView: View {
    @State private var openCandidates = false
    @State private var openRegister = false

    var body: some View {
        NavigationStack {
            AuthenticationView()
            .navigationDestination(isPresented: $openCandidates) {
                CandidatesView()
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
