//
//  GithubRepoRecommendInteractor.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/15.
//

import Foundation

struct GithubRepoRecommendInteractor: UseCaseProtocol {
    
    func execute(_ param: Void, completion: ((Result<[GithubRepoEntity], Never>) -> Void)?) {
        
        //固定データを返すのでNeverを設定
        let entities = [
            GithubRepoEntity(id: 423678109, name: "ParkValidator", htmlURL: URL(string: "https://github.com/boardguy1024/ParkValidator")!, description: "This is the first My framework", stargazersCount: 0),
            GithubRepoEntity(id: 408387131, name: "SwiftUI_CompositionalLayout", htmlURL: URL(string: "https://github.com/boardguy1024/SwiftUI_CompositionalLayout")!, description: "This is the first My framework", stargazersCount: 0)
        ]
        completion?(.success(entities))
    }
    
    func cancel() { }
}
