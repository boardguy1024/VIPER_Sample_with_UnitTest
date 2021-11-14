//
//  GithubRepoSearchPresenter.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation

protocol GithubRepoSearchPresentation: AnyObject {
    func viewDidLoad()
    func search(_ word: String)
    func didSelect(_ entity: GithubRepoEntity)
}

// PresenterがViewに対する責任のプロトコルをPresenter.swiftに書くことでわかりやすくなる
protocol GithubRepoSearchView: AnyObject {
    func showRecommended(_ data: [GithubRepoEntity])
    func showData(_ data: [GithubRepoEntity])
    func showError(_ error: Error)
}

class GithubRepoSearchPresenter {
    
    struct Dependency {
        let interactor: UseCase<String, [GithubRepoEntity], Error>
        let router: GithubRepoSearchWireframe
    }
    
    weak var view: GithubRepoSearchView!
    
    let dependency: Dependency
    
    init(view: GithubRepoSearchView, inject dependency: Dependency) {
        self.view = view
        self.dependency = dependency
    }
}

extension GithubRepoSearchPresenter: GithubRepoSearchPresentation {
    func viewDidLoad() {
        
        // TODO: recommend data
        // dependency.interactor.execute ...
    }
    
    func search(_ word: String) {
        dependency.interactor.execute(word) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let value):
                self.view.showData(value)
            case .failure(let error):
                self.view.showError(error)
            }
        }
    }
    
    func didSelect(_ entity: GithubRepoEntity) {
        dependency.router.showNextView()
    }
    
    
}
