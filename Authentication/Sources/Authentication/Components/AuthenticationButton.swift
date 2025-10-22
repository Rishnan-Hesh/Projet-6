import SwiftUI

//Button
public struct AuthenticationButton: View {
    let title: String
    let action: () -> Void
    
   public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(.vertical, 12)
                .padding(.horizontal, 70)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.primary, lineWidth: 1)
                )
        }
    }
}
