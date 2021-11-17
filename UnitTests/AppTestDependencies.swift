//
//  AppTestDependencies.swift
//  UnitTests
//
//  Created by park kyung seok on 2021/11/16.
//

import Foundation
@testable import VIPER_Sample_with_UnitTest
import UIKit

struct AppTestDependencies: AppDependencies {
    
    func assembleGithubRepoSearchModule() -> UIViewController {
        let viewController = TestDouble.SearchViewController()
        return viewController
    }
    
    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController {
        let viewController = TestDouble.DetailViewController()
        return viewController
    }
    
    
}

extension AppTestDependencies {
    enum TestDouble {
        class SearchViewController: UIViewController {
            
        }
        
        class DetailViewController: UIViewController {

        }
    }
}
