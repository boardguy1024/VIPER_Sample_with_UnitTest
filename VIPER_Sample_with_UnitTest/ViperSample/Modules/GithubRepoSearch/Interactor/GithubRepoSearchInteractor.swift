//
//  GithubRepoSearchInteractor.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation


class GithubRepoSearchInteractor: UseCaseProtocol {
    
    var request: GithubRepoSearchAPIRequest?
    
    func execute(_ param: String, completion: ((Result<[GithubRepoEntity], Error>) -> Void)?) {
        
        let request = GithubRepoSearchAPIRequest(word: param)
        request.perform { result in
            switch result {
            case .success(let response):
                completion?(.success(response.items))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
        
        self.request = request
    }
    
    func cancel() {
        request?.cancel()
    }
}
