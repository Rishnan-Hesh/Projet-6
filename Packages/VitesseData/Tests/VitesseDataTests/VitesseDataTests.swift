import XCTest
import VitesseDomain
@testable import VitesseData

//MARK: - MOCK
@MainActor
final class APIServiceTests: XCTestCase {

    class URLSessionMock: URLSession, @unchecked Sendable {
        var data: Data?
        var response: URLResponse?
        var error: Error?

        override init() {
            super.init()
        }

        override func dataTask(
            with request: URLRequest,
            completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
        ) -> URLSessionDataTask {
            completionHandler(data, response, error)
            return URLSessionDataTaskMock()
        }
    }

    class URLSessionDataTaskMock: URLSessionDataTask {
        override func resume() {}
    }

    var sessionMock: URLSessionMock!
    var apiService: APIService!

    
    override func setUp() {
        super.setUp()
        sessionMock = URLSessionMock()
        apiService = APIService(urlSession: sessionMock)
    }

    func prepareResponse(with json: String, statusCode: Int = 200) {
        sessionMock.data = json.data(using: .utf8)
        sessionMock.response = HTTPURLResponse(
            url: URL(string: "http://127.0.0.1:8080")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        sessionMock.error = nil
    }
    
    
    
    
    //MARK: - TESTS
    func testAuthenticateSuccess() {
        let jsonResponse = #"{"token":"abc123","isAdmin":true}"#
        prepareResponse(with: jsonResponse)
        
        let expectation = self.expectation(description: "Authenticate success")
        apiService.authenticate(email: "test@test.com", password: "password") { result in
            switch result {
            case .success(let authResponse):
                XCTAssertEqual(authResponse.token, "abc123")
                XCTAssertTrue(authResponse.isAdmin)
            case .failure:
                XCTFail("Expected success, got failure")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testAuthenticateNetworkError() {
        sessionMock.error = URLError(.notConnectedToInternet)
        
        let expectation = self.expectation(description: "Authenticate network error")
        apiService.authenticate(email: "", password: "") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, got success")
            case .failure(let error as URLError):
                XCTAssertEqual(error.code, .notConnectedToInternet)
            default:
                XCTFail("Unexpected error type")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    //Fetch candidates
    func testFetchCandidatesSuccess() {
        let jsonResponse = """
        [
            {
                "id": "1",
                "firstName": "Paul",
                "lastName": "Durand",
                "email": "paul@exemple.com",
                "phone": "0612345678",
                "note": "Top profile",
                "linkedInURL": "https://linkedin.com/in/pauldurand"
            },
            {
                "id": "2",
                "firstName": "Anne",
                "lastName": "Lefevre",
                "email": "anne@exemple.com",
                "phone": null,
                "note": null,
                "linkedInURL": null
            }
        ]
        """
        prepareResponse(with: jsonResponse)
        
        let expectation = self.expectation(description: "Fetch candidates success")
        apiService.fetchCandidates(token: "validtoken") { result in
            switch result {
            case .success(let candidates):
                XCTAssertEqual(candidates.count, 2)
                XCTAssertEqual(candidates[0].id, "1")
                XCTAssertEqual(candidates[0].firstName, "Paul")
                XCTAssertEqual(candidates[1].email, "anne@exemple.com")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    func testRegisterUserSuccess() {
        prepareResponse(with: "", statusCode: 201)
        
        let registerRequest = RegisterRequest(
            email: "email@test.com",
            password: "pass",
            firstName: "John",
            lastName: "Doe"
        )
        
        let expectation = self.expectation(description: "Register success")
        apiService.registerUser(request: registerRequest) { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    //Delete
    func testDeleteCandidateSuccess() {
        prepareResponse(with: "", statusCode: 204)
        
        let expectation = self.expectation(description: "Delete candidate success")
        apiService.deleteCandidate(candidateId: "1", token: "token") { result in
            switch result {
            case .success:
                XCTAssertTrue(true)
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    
    //Update
    func testUpdateCandidateSuccess() {
        let candidateJson = """
        {
            "id": "1",
            "firstName": "Paul",
            "lastName": "Durand",
            "email": "paul@exemple.com",
            "phone": "0600000000",
            "note": "Mis à jour",
            "linkedInURL": "https://linkedin.com/in/pauldurand"
        }
        """
        prepareResponse(with: candidateJson)
        
        let candidate = Candidate(
            id: "1",
            firstName: "Paul",
            lastName: "Durand",
            email: "paul@exemple.com",
            phone: "0600000000",
            note: "Mis à jour",
            linkedInURL: "https://linkedin.com/in/pauldurand"
        )
        let expectation = self.expectation(description: "Update candidate success")
        apiService.updateCandidate(candidate: candidate, token: "token") { result in
            switch result {
            case .success(let updatedCandidate):
                XCTAssertEqual(updatedCandidate.note, "Mis à jour")
                XCTAssertEqual(updatedCandidate.firstName, "Paul")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
    
    //Create
    func testCreateCandidateSuccess() {
        let candidateJson = """
        {
            "id": "10",
            "firstName": "Julie",
            "lastName": "Martin",
            "email": "julie@exemple.com",
            "phone": null,
            "note": null,
            "linkedInURL": null
        }
        """
        prepareResponse(with: candidateJson)
        
        let candidate = Candidate(
            id: "",
            firstName: "Julie",
            lastName: "Martin",
            email: "julie@exemple.com"
            
        )
        let expectation = self.expectation(description: "Create candidate success")
        apiService.createCandidate(candidate: candidate, token: "token") { result in
            switch result {
            case .success(let createdCandidate):
                XCTAssertEqual(createdCandidate.firstName, "Julie")
                XCTAssertEqual(createdCandidate.id, "10")
            case .failure:
                XCTFail("Expected success")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}

