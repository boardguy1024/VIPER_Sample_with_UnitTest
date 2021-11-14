//
//  GithubRepoSearchAPIRequest.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation

class GithubRepoSearchAPIRequest {
    private let host = URL(string: "https://api.github.com")!
    private let path = "/search/repositories"
    private let urlSession: Foundation.URLSession
    private var params: [String: String] { ["q": word] }
    
    private var task: URLSessionTask?
    private var word: String
    
    init(urlSession: Foundation.URLSession = URLSession.shared, word: String) {
        self.urlSession = urlSession
        self.word = word
    }
    
    
    func perform(completion: @escaping (Result<GithubRepoSearchResponse, Error>) -> Void) {
        task?.cancel()
        
        var components = URLComponents(url: host, resolvingAgainstBaseURL: false)!
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        print("url: \(components.url!)")
        let request = URLRequest(url: components.url!)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 403 {
                completion(.failure(GithubAPIError.lateLimit))
            }
            
            do {
                let response = try JSONDecoder().decode(GithubRepoSearchResponse.self, from: data!)
                
                print("success -----------------------------------")
                print(response)
                
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
        self.task = task
    }
    
    func cancel() {
        task?.cancel()
    }
}

struct GithubRepoSearchResponse: Decodable {
    let items: [GithubRepoEntity]
}
