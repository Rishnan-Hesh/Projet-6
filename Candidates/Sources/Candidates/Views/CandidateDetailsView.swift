import SwiftUI
import VitesseDomain

public struct CandidateDetailsView: View {
    
    public var candidate: Candidate
    
    public init(candidate: Candidate) {
        self.candidate = candidate
    }
    
   public var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            ComponentsView(candidate: candidate).headerPart
            
            ComponentsView(candidate: candidate).contactInfoPart
            
            ComponentsView(candidate: candidate).linkedInPart
            
            ComponentsView(candidate: candidate).notePart
            
            ComponentsView(candidate: candidate).infoItemsPart(title: "Other", value: "")
            
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    // action ici
                }
            }
        }
    }
}

#Preview("Candidate Details") {
        CandidateDetailsView(candidate: Candidate(
            name: "Jean Michel",
            isFavorite: true
        ))
    }
