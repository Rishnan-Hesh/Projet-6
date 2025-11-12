import XCTest
import VitesseData
@testable import Authentication

final class MockAPIService: AuthenticationServiceProtocol, @unchecked Sendable {
    var shouldSucceed = true
    var lastAuthEmail: String?
    var lastAuthPassword: String?
    var response: AuthResponse = AuthResponse(token: "mockToken", isAdmin: false)

    func authenticate(
        email: String,
        password: String,
        completion: @escaping @Sendable (Result<AuthResponse, Error>) -> Void
    ) {
        lastAuthEmail = email
        lastAuthPassword = password
        if shouldSucceed {
            completion(.success(response))
        } else {
            completion(.failure(URLError(.userAuthenticationRequired)))
        }
    }
}

@MainActor
final class AuthenticationViewModelTests: XCTestCase {
    var viewModel: AuthenticationViewModel!
    var mockAPI: MockAPIService!

    override func setUp() {
        super.setUp()
        mockAPI = MockAPIService()
        viewModel = AuthenticationViewModel(apiService: mockAPI)
    }

    func testInitialState() {
        XCTAssertEqual(viewModel.email, "")
        XCTAssertEqual(viewModel.password, "")
        XCTAssertFalse(viewModel.isLoginEnabled)
        XCTAssertNil(viewModel.token)
        XCTAssertNil(viewModel.loginErrorMessage)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertFalse(viewModel.isForgotPasswordError)
        XCTAssertFalse(viewModel.isAdmin)
    }

    func testResetErrorsClearsState() {
        viewModel.loginErrorMessage = "Fake error"
        viewModel.isForgotPasswordError = true
        viewModel.resetErrors()
        XCTAssertNil(viewModel.loginErrorMessage)
        XCTAssertFalse(viewModel.isForgotPasswordError)
    }

    func testIsValidEmail() {
        XCTAssertTrue(AuthenticationViewModel.isValidEmail("toto@gmail.com"))
        XCTAssertFalse(AuthenticationViewModel.isValidEmail("not-an-email"))
        XCTAssertFalse(AuthenticationViewModel.isValidEmail(""))
    }

    func testForgotPasswordSetsErrorFlag() {
        viewModel.isForgotPasswordError = false
        viewModel.forgotPassword()
        XCTAssertTrue(viewModel.isForgotPasswordError)
    }

    func testSignInSuccessSetsTokenAndAdmin() {
        viewModel.email = "valid@mail.com"
        viewModel.password = "pass"
        mockAPI.shouldSucceed = true
        mockAPI.response = AuthResponse(token: "tok", isAdmin: true)
        viewModel.signIn()
        let expectation = XCTestExpectation(description: "Wait for sign-in success")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(self.viewModel.token, "tok")
            XCTAssertTrue(self.viewModel.isAdmin)
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.loginErrorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }

    func testSignInFailureSetsErrorMessage() {
        viewModel.email = "fail@email.com"
        viewModel.password = "wrongpass"
        mockAPI.shouldSucceed = false
        viewModel.signIn()
        let expectation = XCTestExpectation(description: "Wait for sign-in failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            XCTAssertEqual(self.viewModel.loginErrorMessage, "Identifiants incorrects ou erreur réseau")
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertNil(self.viewModel.token)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}
