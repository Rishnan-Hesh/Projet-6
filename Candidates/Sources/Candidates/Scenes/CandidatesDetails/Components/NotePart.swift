import SwiftUI
import VitesseDomain


public struct notePart: View {
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Note")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.top, 30)
            
            Text("Think about the next meeting.")
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.07), radius: 1, x: 0, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.separator), lineWidth: 1)
                        )
                )
                .font(.body)
        }
    }
}
