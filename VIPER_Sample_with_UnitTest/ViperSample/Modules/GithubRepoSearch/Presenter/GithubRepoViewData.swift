//
//  GithubRepoViewData.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/15.
//

import Foundation

class GithubRepoViewData {
    enum Section: Int, CaseIterable {
        case recommend
        case search
    }
    
    var recommends: [GithubRepoEntity] = []
    var searchResultEntities: [GithubRepoEntity] = []
    
    var numberOfSEctions: Int {
        Section.allCases.count
    }
    
    func title(of section: Int) -> String {
        switch Section(rawValue: section)! {
        case .recommend:
            return "おすすめ"
        case .search:
            return "検索結果 \(searchResultEntities.count)件"
        }
    }
    
    func numberOfItems(in section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .recommend:
            return recommends.count
        case .search:
            return searchResultEntities.count
            
        }
    }
    
    func item(with indexPath: IndexPath) -> GithubRepoEntity? {
        switch Section(rawValue: indexPath.section)! {
        case .recommend:
            
            // (0,1,2,3,4,5).countains(..  indexPath.rowが含まれていない場合は nilを返す
            guard (0 ..< recommends.count).contains(indexPath.row) else { return nil }
            return recommends[indexPath.row]
            
        case .search:
            
            guard (0 ..< searchResultEntities.count).contains(indexPath.row) else { return nil }
            return searchResultEntities[indexPath.row]
        }
    }
    
}
