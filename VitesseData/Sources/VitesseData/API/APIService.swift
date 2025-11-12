import Foundation
import VitesseDomain

@MainActor
public final class APIService {
    public static let shared = APIService()
    private let baseURL = URL(string: "http://127.0.0.1:8080")!
    private let urlSession: URLSession

    // Init pour app et tests
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - User Auth (post)
    public func authenticate(
        email: String, password: String,
        completion: @escaping @Sendable (Result<AuthResponse, Error>) -> Void) {
        let endpoint = baseURL.appendingPathComponent("user/auth")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = AuthRequest(email: email, password: password)
        request.httpBody = try? JSONEncoder().encode(body)
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[Auth] Erreur réseau : \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[Auth] Statut HTTP : \(httpResponse.statusCode)")
            }
            if let data = data {
                print("[Auth] Payload brut : \(String( data: data, encoding: .utf8) ?? "nil")")
                if let result = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                    print("[Auth] Décodé : \(result)")
                    completion(.success(result))
                } else {
                    print("[Auth] Erreur decoding : \(data)")
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } else {
                print("[Auth] Pas de data reçue")
                completion(.failure(URLError(.badServerResponse)))
            }
        }.resume()
    }
    
    // MARK: - Get Candidate
    public func fetchCandidates(
        token: String,
        completion: @escaping @Sendable (Result<[Candidate], Error>) -> Void) {
        let endpoint = baseURL.appendingPathComponent("candidate")
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[GET] Network error : \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[GET] Statut HTTP : \(httpResponse.statusCode)")
            }
            if let data = data {
                print("[GET] Payload brut : \(String( data: data, encoding: .utf8) ?? "nil")")
                if let candidates = try? JSONDecoder().decode([Candidate].self, from: data) {
                    print("[GET] Decoded : \(candidates)")
                    completion(.success(candidates))
                } else {
                    print("[GET] Erreur decoding : \(data)")
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } else {
                print("[GET] no data")
                completion(.failure(URLError(.badServerResponse)))
            }
        }.resume()
    }
    
    // MARK: - Register
    public func registerUser(
        request: RegisterRequest,
        completion: @escaping (Result<Void, Error>) -> Void) {
        let endpoint = baseURL.appendingPathComponent("user/register")
        var urlRequest = URLRequest(url: endpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
            
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let httpResp = response as? HTTPURLResponse, httpResp.statusCode == 201 {
                completion(.success(()))
            } else {
                completion(.failure(error ?? URLError(.badServerResponse)))
            }
        }.resume()
    }
    
    public func deleteCandidate(
        candidateId: String,
        token: String,
        completion: @escaping @Sendable (Result<Void, Error>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidateId)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[DELETE] Erreur réseau : \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[DELETE] Statut HTTP : \(httpResponse.statusCode)")
            }
            if let data = data {
                print("[DELETE] Payload brut : \(String( data: data, encoding: .utf8) ?? "nil")")
            } else {
                print("[DELETE] Pas de data reçue")
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                completion(.success(()))
            } else {
                completion(.failure(error ?? URLError(.badServerResponse)))
            }
        }.resume()
    }
    
    public func updateCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    ) {
        guard let url = URL(string: "http://127.0.0.1:8080/candidate/\(candidate.id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(candidate)

        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[PUT] Erreur réseau : \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[PUT] Statut HTTP : \(httpResponse.statusCode)")
            }
            if let data = data {
                print("[PUT] Payload brut : \(String( data: data, encoding: .utf8) ?? "nil")")
                if let updated = try? JSONDecoder().decode(Candidate.self, from: data) {
                    print("[PUT] Décodé : \(updated)")
                    completion(.success(updated))
                } else {
                    print("[PUT] Erreur decoding : \(data)")
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } else {
                print("[PUT] Pas de data reçue")
                completion(.failure(URLError(.badServerResponse)))
            }
        }.resume()
    }
    
    public func createCandidate(
        candidate: Candidate,
        token: String,
        completion: @escaping @Sendable (Result<Candidate, Error>) -> Void
    ) {
        let url = URL(string: "http://127.0.0.1:8080/candidate")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try? JSONEncoder().encode(candidate)
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                print("[POST] Erreur réseau : \(error)")
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("[POST] Statut HTTP : \(httpResponse.statusCode)")
            }
            if let data = data {
                print("[POST] Payload brut : \(String( data: data, encoding: .utf8) ?? "nil")")
                if let created = try? JSONDecoder().decode(Candidate.self, from: data) {
                    print("[POST] Décodé : \(created)")
                    completion(.success(created))
                } else {
                    print("[POST] Erreur decoding : \(data)")
                    completion(.failure(URLError(.cannotParseResponse)))
                }
            } else {
                print("[POST] Pas de data reçue")
                completion(.failure(URLError(.badServerResponse)))
            }
        }.resume()
    }
}

