//
//  GithubRepoSearchRouter.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation
import UIKit

protocol GithubRepoSearchWireframe {
    var searchViewController: UIViewController { get }
    
    func showDetailView(entity: GithubRepoEntity)
    func showError(error: Error)
}

struct GithubRepoSearchRouter: GithubRepoSearchWireframe {
    
    let appDependencies: AppDependencies
    
    unowned var searchViewController: UIViewController
    
    func showDetailView(entity: GithubRepoEntity) {
        // assemble~~~ModuleはDIセットが完了しているモニュールのViewControllerを返す
        let viewController = appDependencies.assembleGithubRepoDetailModule(githubRepoEntity: entity)
        searchViewController.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func showError(error: Error) {
        let alert = UIAlertController(title: "通信ヘラー", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        searchViewController.present(alert, animated: true)
    }
    
 
}
