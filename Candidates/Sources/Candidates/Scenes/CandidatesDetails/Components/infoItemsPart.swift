import SwiftUI
import VitesseDomain

public func infoItemsPart(title: String, value: String) -> some View {
    VStack(alignment: .leading) {
        Text(title)
            .font(.caption)
            .foregroundColor(.gray)
        Text(value)
            .font(.body)
    }
}
