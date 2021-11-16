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
}

class GithubRepoSearchPresenter {
    
    struct Dependency {
        let recommendInteractor: UseCase<Void, [GithubRepoEntity], Never>
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
                
        dependency.recommendInteractor.execute(()) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.view.showRecommended(value)
                    
                case .failure(_):
                    print("固定値を返すのでここは何もしない")
                }
            }
        }
    }
    
    func search(_ word: String) {
        dependency.interactor.execute(word) { result in
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let value):
                    self.view.showData(value)
                case .failure(let error):
                    if (error as NSError).code != NSURLErrorCancelled {
                        self.dependency.router.showError(error: error)
                    }
                }
            }
           
        }
    }
    
    func didSelect(_ entity: GithubRepoEntity) {
        dependency.router.showDetailView(entity: entity)
    }
    
    
}
