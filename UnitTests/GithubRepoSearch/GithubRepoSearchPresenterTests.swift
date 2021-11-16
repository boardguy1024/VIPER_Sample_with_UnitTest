//
//  GithubRepoSearchPresenterTests.swift
//  UnitTests
//
//  Created by park kyung seok on 2021/11/16.
//

import XCTest
@testable import VIPER_Sample_with_UnitTest

class GithubRepoSearchPresenterTests: XCTestCase {
    
    // このテストはPresenterの入力をテストする
    private var presenter: GithubRepoSearchPresenter!
    
    private let searchViewController = TestDouble.ViewController()
    
    func testPresenterInput() {
        
        // Interactorは通信しないでダミーを返す
        let searchInteractor = TestDouble.SearchInteractor()
        let router = TestDouble.Router(viewController: searchViewController)
        
        let dependendy = GithubRepoSearchPresenter.Dependency(recommendInteractor: UseCase(GithubRepoRecommendInteractor()), interactor: UseCase(searchInteractor), router: router)
        presenter = GithubRepoSearchPresenter(view: searchViewController, inject: dependendy)
        
        presenter.viewDidLoad()
        
        
        XCTContext.runActivity(named: "searchを一度も呼び出していない場合") { _ in
            XCTContext.runActivity(named: "Sectionのcountとタイトルは固定値を返す") { _ in
                XCTAssertEqual(searchViewController.displayData.numberOfSections, 2)
                XCTAssertEqual(searchViewController.displayData.title(of: 0), "おすすめ")
                XCTAssertEqual(searchViewController.displayData.title(of: 1), "検索結果 0件")
            }
            
            XCTContext.runActivity(named: "Section: 0は固定値を返す") { _ in
                let section = 0
                
                XCTContext.runActivity(named: "Section: 0") { _ in
                    let exp = XCTestExpectation()
                    
                    // ここで data: GithubRepoViewData を受け取る {  } をセット
                    // テストが実行されるとクロージャーが呼ばれる
                    // このクロージャが呼ばれるようにするには presenter.viewDidLoad()をすることで showRecommendメソッドが実行され
                    //TestDouble.ViewController内のshowRecommendが実行されることでこのクロージャーが呼ばれる
                    searchViewController.recommendCompletion = { data in
                        
                        defer {
                            exp.fulfill()
                        }
                        
                        XCTAssertEqual(data.numberOfItems(in: section), 2)
                        XCTAssertEqual(data.item(with: IndexPath(item: 0, section: section))?.name, "ParkValidator")
                        XCTAssertEqual(data.item(with: IndexPath(item: 1, section: section))?.name, "SwiftUI_CompositionalLayout")
                        
                    }
                    
                    wait(for: [exp], timeout: 5)
                }
                
                //　Section: 0内のセルをタップ
                XCTContext.runActivity(named: "Section: 0をタップ") { _ in
                    
                    XCTContext.runActivity(named: "row: 0をタップ") { _ in
                        let indexPath = IndexPath(row: 0, section: section)
                        let entity = searchViewController.displayData.item(with: indexPath)
                        
                        presenter.didSelect(entity!)
                        
                        XCTAssertEqual(router.entity?.name, "ParkValidator")
                    }
                    
                    XCTContext.runActivity(named: "row: 1をタップ") { _ in
                        let indexPath = IndexPath(row: 1, section: section)
                        let entity = searchViewController.displayData.item(with: indexPath)
                        
                        presenter.didSelect(entity!)
                        
                        XCTAssertEqual(router.entity?.name, "SwiftUI_CompositionalLayout")
                    }
                }
                
                XCTContext.runActivity(named: "Searchはまだ検索前なのでSection: 1はデータ数が0") { _ in
                    let section = 1
                    
                    XCTAssertEqual(searchViewController.displayData.numberOfItems(in: section), 0)
                }
                
            }
            
            XCTContext.runActivity(named: "searchを呼び出した後") { _ in
                
                //ダミーデータ注入
                searchInteractor.stubData = [
                    GithubRepoEntity(id: 1, name: "name0", htmlURL: URL(string: "http://example.com/0")!, description: "", stargazersCount: 0),
                    GithubRepoEntity(id: 2, name: "name1", htmlURL: URL(string: "http://example.com/1")!, description: "", stargazersCount: 0)
                ]
                
                presenter.search("")
                
                XCTContext.runActivity(named: "Section: 1は用意されたstubDataが返すようにする") { _ in
                    
                    let section = 1
                    
                    let exp = XCTestExpectation()
                    
                    searchViewController.searchedCompletion = { data in
                        defer {
                            exp.fulfill()
                        }
                        
                        XCTContext.runActivity(named: "用意したStubDataを返す") { _ in
                            XCTAssertEqual(data.numberOfItems(in: section), 2)
                            
                            XCTAssertEqual(data.item(with: IndexPath(item: 0, section: section))?.id, 1)
                            XCTAssertEqual(data.item(with: IndexPath(item: 1, section: section))?.id, 2)
                        }
                    }
                    
                    wait(for: [exp], timeout: 5)
                    
                    
                    XCTContext.runActivity(named: "セルをタップ") { _ in
                        
                        XCTContext.runActivity(named: "Section1: 0のセルをタップ") { _ in
                            let entity = searchViewController.displayData.item(with: IndexPath(item: 0, section: section))
                            self.presenter.didSelect(entity!)
                            XCTAssertEqual(router.entity?.name, "name0")
                        }
                     
                        XCTContext.runActivity(named: "Section1: 1のセルをタップ") { _ in
                            let entity = searchViewController.displayData.item(with: IndexPath(item: 1, section: section))
                            self.presenter.didSelect(entity!)
                            XCTAssertEqual(router.entity?.name, "name1")
                        }
                    }
                }
            }
        }
    }
    
    func testPresenterErrorHandling() {
        
        XCTContext.runActivity(named: "エラーが発生してRouterが感知できる") { _ in
            let router = TestDouble.Router(viewController: searchViewController)
            router.error = nil //初期化
            
            let searchErrorInteractor = TestDouble.SearchErrorInteractor()
            // Errorをセット
            searchErrorInteractor.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: nil)
            
            let dependency = GithubRepoSearchPresenter.Dependency(recommendInteractor: UseCase(GithubRepoRecommendInteractor()),
                                                                  interactor: UseCase(searchErrorInteractor),
                                                                  router: router)
            
            let presenter = GithubRepoSearchPresenter(view: searchViewController, inject: dependency)
            
            XCTContext.runActivity(named: "Routerで取得したErrorが用意したものなのか？") { _ in
                
                let exp = XCTestExpectation()
                
                searchErrorInteractor.errorHandler = {
               
                    exp.fulfill()
                    
                    let error = router.error! as NSError
                    XCTAssertEqual(error.domain, NSURLErrorDomain)
                    XCTAssertEqual(error.code, NSURLErrorUnknown)
                    
                }
                presenter.search("")

                wait(for: [exp], timeout: 5)
            }
        }
        
        XCTContext.runActivity(named: "キャンセルエラーはRouterが感知しない") { _ in
            let router = TestDouble.Router(viewController: searchViewController)
            router.error = nil //初期化
            
            let searchErrorInteractor = TestDouble.SearchErrorInteractor()
            // Errorをセット
            searchErrorInteractor.error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled, userInfo: nil)
            
            let dependency = GithubRepoSearchPresenter.Dependency(recommendInteractor: UseCase(GithubRepoRecommendInteractor()),
                                                                  interactor: UseCase(searchErrorInteractor),
                                                                  router: router)
            
            let presenter = GithubRepoSearchPresenter(view: searchViewController, inject: dependency)
            
            XCTContext.runActivity(named: "Routerで取得したErrorが用意したものなのか？") { _ in
                
                let exp = XCTestExpectation()
                
                searchErrorInteractor.errorHandler = {
               
                    exp.fulfill()
                    
                    // NSURLErrorCancelledの場合、Errorは流れない
                    XCTAssertNil(router.error)
                }
                presenter.search("")

                wait(for: [exp], timeout: 5)
            }
        }
        
        
    }
}

extension GithubRepoSearchPresenterTests {
    
    enum TestDouble {
        class ViewController: UIViewController, GithubRepoSearchView {
            
            let displayData = GithubRepoViewData()
            var recommendCompletion: ((GithubRepoViewData) -> Void)?
            var searchedCompletion: ((GithubRepoViewData) -> Void)?
            
            func showRecommended(_ data: [GithubRepoEntity]) {
                displayData.recommends = data
                // displayDataを持ってCompletionを実行
                recommendCompletion?(displayData)
            }
            
            func showData(_ data: [GithubRepoEntity]) {
                displayData.searchResultEntities = data
                searchedCompletion?(displayData)
            }
            
            func showError(_ error: Error) { }
        }
        
        class Router: GithubRepoSearchWireframe {
            var searchViewController: UIViewController
            var entity: GithubRepoEntity?
            var error: Error?
            
            init(viewController: UIViewController) {
                self.searchViewController = viewController
            }
            
            func showDetailView(entity: GithubRepoEntity) {
                self.entity = entity
            }
            
            func showError(error: Error) {
                self.error = error
            }
        }
        
        class SearchInteractor: UseCaseProtocol {
         
            // テスト用入力としてセットし出力するスタブ
            var stubData: [GithubRepoEntity]?
            
            func execute(_ param: String, completion: ((Result<[GithubRepoEntity], Error>) -> Void)?) {
                completion?(.success(stubData ?? []))
            }
            
            func cancel() { }
        }
        
        class SearchErrorInteractor: UseCaseProtocol {
          
            var error: Swift.Error!
            var errorHandler: (() -> Void)?
            
            func execute(_ param: String, completion: ((Result<[GithubRepoEntity], Error>) -> Void)?) {
                completion?(.failure(error))
                
                DispatchQueue.main.async {
                    self.errorHandler?()
                }
            }
            
            func cancel() {}
        }
        
        
    }
}


