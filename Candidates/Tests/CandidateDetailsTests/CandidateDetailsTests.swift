import XCTest
import VitesseDomain
@testable import Candidates

@MainActor
final class CandidateDetailsViewModelTests: XCTestCase {
    var candidate: Candidate!
    var mockAPI: MockAPIService!
    var viewModel: CandidateDetailsViewModel!

    override func setUp() {
        // Constructeur
        candidate = Candidate(id: "1", firstName: "Jane", lastName: "Doe", email: "jane@x.com", phone: nil, note: "Note", linkedInURL: nil)
        mockAPI = MockAPIService()
        viewModel = CandidateDetailsViewModel(candidate: candidate, apiService: mockAPI)
    }

    func test_updateCandidate_success() async {
        // Simule le retour positif
        let updated = Candidate(id: "1", firstName: "John", lastName: "Smith", email: "john@x.com", phone: nil, note: "ok", linkedInURL: nil)
        mockAPI.candidateToReturn = updated
        let expectation = XCTestExpectation(description: "updateCandidate callback")

        viewModel.updateCandidate(token: "toto") { result in
            switch result {
            case .success(let updatedC):
                XCTAssertEqual(updatedC.firstName, "John")
                expectation.fulfill()
            case .failure:
                XCTFail("Should succeed")
            }
        }

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.candidate.firstName, "John")
        XCTAssertTrue(mockAPI.updateCandidateCalled)
        XCTAssertEqual(mockAPI.receivedToken, "toto")
    }

    func test_updateCandidate_failure() async {
        mockAPI.shouldReturnError = true
        let expectation = XCTestExpectation(description: "updateCandidate fail")

        viewModel.updateCandidate(token: "tata") { result in
            switch result {
            case .success:
                XCTFail("Should not succeed")
            case .failure(let error):
                XCTAssertNotNil(error)
                expectation.fulfill()
            }
        }

        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.errorMessage, "Erreur lors de la modification")
        XCTAssertFalse(viewModel.isLoading)
    }

    func test_updateCandidateLocal_setsCandidate() {
        let newCandidate = Candidate(id: "1", firstName: "Alice", lastName: "Poe", email: "alice.poe@gmail.com", phone: nil, note: nil, linkedInURL: nil)
        viewModel.updateCandidateLocal(newCandidate)
        XCTAssertEqual(viewModel.candidate.firstName, "Alice")
        XCTAssertEqual(viewModel.candidate.lastName, "Poe")
        XCTAssertEqual(viewModel.candidate.email, "alice.poe@gmail.com")
    }
}
