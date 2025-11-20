import SwiftUI

struct AddCandidateForm: View {
    @ObservedObject var viewModel: CandidatesListViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let token: String
    
    var body: some View {
        VStack(spacing: 24) {
            
            Text("Add Candidate")
                .font(.headline)
                .padding(.top, 32)
            
            VStack(spacing: 16) {
                Group {
                    TextField("Name", text: $viewModel.candidateFirstName)
                    TextField("Surname", text: $viewModel.candidateLastName)
                    TextField("Email", text: $viewModel.candidateEmail)
                    TextField("Phone", text: $viewModel.candidatePhone)
                    TextField("Note", text: bindingOptional($viewModel.candidateNote))
                    TextField("LinkedIn link", text: bindingOptional($viewModel.candidateLinkedinURL))
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            Button(action: {
                viewModel.createCandidate(token: token)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .ignoresSafeArea(.keyboard)
    }
    
    private func bindingOptional(_ binding: Binding<String?>) -> Binding<String> {
        Binding<String>(
            get: { binding.wrappedValue ?? "" },
            set: { binding.wrappedValue = $0 }
        )
    }
}
