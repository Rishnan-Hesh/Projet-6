import SwiftUI
import VitesseDomain

public struct linkedInPart: View {
    
    public var body: some View {
        HStack {
            Text("LinkedIn")
                .font(.caption)
            Spacer()
            Button("Go on LinkedIn") {
                // action
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(6)
            .padding(.horizontal, 90)
        }
    }
}
