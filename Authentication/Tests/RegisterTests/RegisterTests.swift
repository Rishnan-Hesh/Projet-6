import XCTest
import VitesseData
@testable import Authentication


final class RegisterViewModelTests: XCTestCase {
    var viewModel: RegisterViewModel!
    var mockAPI: MockRegisterAPIService!

    override func tearDown() {
        viewModel = nil
        mockAPI = nil
        super.tearDown()
    }

    @MainActor
    func testInitialState() {
        mockAPI = MockRegisterAPIService()
        viewModel = RegisterViewModel(registerUserClosure: mockAPI.registerUser)

        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertEqual(viewModel.confirmPassword, "")
        XCTAssertEqual(viewModel.firstName, "")
        XCTAssertEqual(viewModel.lastName, "")
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.registerErrorMessage)
        XCTAssertFalse(viewModel.passwordsMatch)
    }

    @MainActor
    func testPasswordsMatchProperty() {
        mockAPI = MockRegisterAPIService()
        viewModel = RegisterViewModel(registerUserClosure: mockAPI.registerUser)

        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"
        XCTAssertTrue(viewModel.passwordsMatch)

        viewModel.confirmPassword = "Password not matched"
        XCTAssertFalse(viewModel.passwordsMatch)

        viewModel.password = ""
        viewModel.confirmPassword = ""
        XCTAssertFalse(viewModel.passwordsMatch)
    }

    @MainActor
    func testSignUpSuccess() async {
        mockAPI = MockRegisterAPIService()
        viewModel = RegisterViewModel(registerUserClosure: mockAPI.registerUser)
        
        viewModel.email = "test@mail.com"
        viewModel.password = "pass123"
        viewModel.confirmPassword = "pass123"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        mockAPI.shouldSucceed = true

        let expectation = XCTestExpectation(description: "Registration success")
        viewModel.signUp { success in
            XCTAssertTrue(success)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.registerErrorMessage)
            XCTAssertEqual(self.mockAPI.lastRegisterRequest?.email, "test@mail.com")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }

    @MainActor
    func testSignUpFailure() async {
        mockAPI = MockRegisterAPIService()
        viewModel = RegisterViewModel(registerUserClosure: mockAPI.registerUser)
        
        viewModel.email = "test@mail.com"
        viewModel.password = "pass123"
        viewModel.confirmPassword = "pass123"
        viewModel.firstName = "John"
        viewModel.lastName = "Doe"
        mockAPI.shouldSucceed = false

        let expectation = XCTestExpectation(description: "Registration failure")
        viewModel.signUp { success in
            XCTAssertFalse(success)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertEqual(self.viewModel.registerErrorMessage, "Something hapened, please try again.")
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 1)
    }
}
