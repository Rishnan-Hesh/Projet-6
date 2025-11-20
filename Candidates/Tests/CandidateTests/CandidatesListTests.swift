import XCTest
import VitesseDomain
@testable import Candidates

@MainActor
final class CandidatesListViewModelTests: XCTestCase {
    var viewModel: CandidatesListViewModel!
    var mockService: MockCandidateService!

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testInitialState() {
        mockService = MockCandidateService()
        viewModel = CandidatesListViewModel(service: mockService)

        XCTAssertEqual(viewModel.candidates.count, 0)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isEditing)
        XCTAssertEqual(viewModel.searchText, "")
        XCTAssertFalse(viewModel.showFavoritesOnly)
        XCTAssertEqual(viewModel.selection.count, 0)
        XCTAssertFalse(viewModel.isCreatingCandidate)
        XCTAssertNil(viewModel.createCandidateErrorMessage)
    }

    func testFetchCandidatesSuccess() async {
        mockService = MockCandidateService()
        let candidate = Candidate(
            id: "id1",
            firstName: "John",
            lastName: "Doe",
            email: "j@email.com",
            phone: "0612345678",
            note: nil,
            linkedInURL: nil
        )
        mockService.candidatesToReturn = [candidate]
        viewModel = CandidatesListViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Fetch candidates")
        viewModel.loadCandidates(token: "token")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.candidates.count, 1)
            XCTAssertEqual(self.viewModel.candidates.first?.firstName, "John")
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testFetchCandidatesFailure() async {
        mockService = MockCandidateService()
        mockService.shouldFetchSucceed = false
        viewModel = CandidatesListViewModel(service: mockService)

        let expectation = XCTestExpectation(description: "Fetch fail")
        viewModel.loadCandidates(token: "token")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.candidates.isEmpty)
            XCTAssertEqual(self.viewModel.errorMessage, "Unable to load candidates")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testCreateCandidateSuccess() async {
        mockService = MockCandidateService()
        viewModel = CandidatesListViewModel(service: mockService)

        viewModel.candidateFirstName = "Jane"
        viewModel.candidateLastName = "Doe"
        viewModel.candidateEmail = "jane@email.com"
        viewModel.candidatePhone = "0699999999"

        let expectation = XCTestExpectation(description: "Create candidate success")

        viewModel.createCandidate(token: "token")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.candidates.count, 1)
            XCTAssertEqual(self.viewModel.candidates.first?.firstName, "Jane")
            XCTAssertFalse(self.viewModel.isCreatingCandidate)
            XCTAssertNil(self.viewModel.createCandidateErrorMessage)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testCreateCandidateFailure() async {
        mockService = MockCandidateService()
        mockService.shouldCreateSucceed = false
        viewModel = CandidatesListViewModel(service: mockService)

        viewModel.candidateFirstName = "Jean"
        viewModel.candidateLastName = "Dupont"
        viewModel.candidateEmail = "jean@email.com"
        viewModel.candidatePhone = "0699998888"

        let expectation = XCTestExpectation(description: "Create candidate fail")

        viewModel.createCandidate(token: "token")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.candidates.isEmpty)
            XCTAssertNotNil(self.viewModel.createCandidateErrorMessage)
            XCTAssertFalse(self.viewModel.isCreatingCandidate)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testDeleteCandidate() async {
        mockService = MockCandidateService()
        mockService.shouldDeleteSucceed = true
        let candidate = Candidate(
            id: "deleteID",
            firstName: "ToDelete",
            lastName: "Guy",
            email: "",
            phone: "",
            note: nil,
            linkedInURL: nil
        )
        viewModel = CandidatesListViewModel(service: mockService)
        viewModel.candidates = [candidate]

        let expectation = XCTestExpectation(description: "Delete candidate")

        viewModel.deleteCandidate(withId: "deleteID", token: "token")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertFalse(self.viewModel.candidates.contains { $0.id == "deleteID" })
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }

    func testUpdateCandidate() async {
        mockService = MockCandidateService()
        mockService.shouldUpdateSucceed = true
        let candidate = Candidate(
            id: "updateId",
            firstName: "Init",
            lastName: "User",
            email: "",
            phone: "",
            note: nil,
            linkedInURL: nil
        )
        viewModel = CandidatesListViewModel(service: mockService)
        viewModel.candidates = [candidate]

        let updated = Candidate(
            id: "updateId",
            firstName: "Updated",
            lastName: "User",
            email: "",
            phone: "",
            note: nil,
            linkedInURL: nil
        )
        let expectation = XCTestExpectation(description: "Update candidate")

        viewModel.updateCandidate(updated, token: "token")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.viewModel.candidates.first?.firstName, "Updated")
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
}
