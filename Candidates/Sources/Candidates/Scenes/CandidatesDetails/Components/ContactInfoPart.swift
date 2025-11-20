import SwiftUI
import VitesseDomain

public struct contactInfoPart: View {
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            infoItemsPart(title: "Phone", value: "09 12 12 32 32")
            infoItemsPart(title: "Email", value: "jeanmichelp@toto.com")
        }    }
}
