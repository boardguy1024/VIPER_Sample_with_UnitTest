//
//  AppDependency.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import UIKit

protocol AppDependency {
    // UIViewControllerを返すようにする
    
    //各モジュールを返すメソッド
    //モジュールのメインパーツ同士の依存性を解決して(DI:依存性注入) UIViewControllerを返す
    func assembleGithubRepoSearchModule() -> UIViewController
    
    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController
}

//　Clean Architecture本でいうところの、「メインモジュール」
public struct AppDefaultDependency {
    
    public init() { }
    
    // このスコープには rootViewControllerを返すメソッドが必要
    public func rootViewController() -> UIViewController {
        // テスト時に必要であれば、対象画面を入れ替える
        assembleGithubRepoSearchModule()
    }
}

extension AppDefaultDependency: AppDependency {
    
    func assembleGithubRepoSearchModule() -> UIViewController {
        let vc = { () -> GithubRepoSearchViewController in
            let storyboard = UIStoryboard(name: "GithubRepoSearch", bundle: nil)
            return storyboard.instantiateInitialViewController() as! GithubRepoSearchViewController
        }()
        
        // Dependency inject...
        let router = GithubRepoSearchRouter()
        let interactor = UseCase(GithubRepoSearchInteractor())
        
        vc.dependency = .init(presenter: GithubRepoSearchPresenter(view: vc, inject: GithubRepoSearchPresenter.Dependency(interactor: interactor, router: router)))
        
        return vc
    }
    
    func assembleGithubRepoDetailModule(githubRepoEntity: GithubRepoEntity) -> UIViewController {
        UIViewController()
    }
    
    
}
