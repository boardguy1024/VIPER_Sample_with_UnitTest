//
//  GithubRepoEntity.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation

struct GithubRepoEntity: Decodable, Identifiable, Equatable {
    let id: Int
    let name: String
    let htmlURL: URL
    let description: String?
    let stargazersCount: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case htmlURL = "html_url"
        case description
        case stargazersCount = "stargazers_count"
    }
    
    //GithubのEntityには idが存在しているので Identifableを準拠して
    // idを使い、オブジェクト同士を比較できるようにする
    // 主にテストコードで利用する。
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
