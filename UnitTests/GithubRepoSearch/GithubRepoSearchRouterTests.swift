//
//  GithubRepoSearchRouterTests.swift
//  UnitTests
//
//  Created by park kyung seok on 2021/11/17.
//

import XCTest
@testable import VIPER_Sample_with_UnitTest

class GithubRepoSearchRouterTests: XCTestCase {

    private var router: GithubRepoSearchRouter!
    private let searchViewController = AppTestDependencies.TestDouble.SearchViewController()
    
    // テストの開始時に最初に一度呼ばれる関数。テストケースを回すために必要な設定やインスタンスの生成などをここで行います。
    override func setUp() {
        let navigationController = UINavigationController(rootViewController: searchViewController)
        
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        window?.rootViewController = navigationController
        router = GithubRepoSearchRouter(appDependencies: AppTestDependencies(),
                                        searchViewController: searchViewController)
    }
    
    func testDetailViewControllerIsPushed() {
        setUp()
        
        XCTContext.runActivity(named: "Entityを渡されて表示する場合") { _ in
            
            //ダミーデータを作成
            let entity = GithubRepoEntity(id: 1,
                                          name: "name0",
                                          htmlURL: URL(string: "http://apple.com")!,
                                          description: "",
                                          stargazersCount: nil)
            
            router.showDetailView(entity: entity)
            
            let exp = XCTestExpectation()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                defer {
                    exp.fulfill()
                }
                
                let navigation = self.searchViewController.navigationController
                let pushedViewController = navigation?.visibleViewController
                
                XCTAssertTrue(pushedViewController is AppTestDependencies.TestDouble.DetailViewController)
            }
            
            wait(for: [exp], timeout: 5)
        }
        
    }
    
    func testShowErrorAlart() {
        setUp()
        
        XCTContext.runActivity(named: "Errorを渡されて表示する場合") { _ in
            
            router.showError(error: TestDouble.Error())
            let exp = XCTestExpectation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                defer {
                    exp.fulfill()
                }
                
                
                let window = UIApplication.shared.windows.first { $0.isKeyWindow }
    
                // 遷移先で .present()で遷移された presentedViewController
                let viewController = window?.rootViewController?.presentedViewController
                let presentedViewController = viewController as? UIAlertController

                XCTAssertEqual(presentedViewController?.message, "エラー文言!!!")
            }
            
            wait(for: [exp], timeout: 5)
        }
    }
    
    

}

extension GithubRepoSearchRouterTests {
    enum TestDouble {
        struct Error: Swift.Error, LocalizedError {
            var errorDescription: String? { "エラー文言!!!" }
        }
    }
}
