//
//  GithubRepoSearchViewController.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import UIKit

class GithubRepoSearchViewController: UIViewController {
    
    struct Dependency {
        let presenter: GithubRepoSearchPresentation
    }
    
    var dependency: Dependency!

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        dependency.presenter.viewDidLoad()
    }
    
}

extension GithubRepoSearchViewController {
    private func setupUI() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.hidesSearchBarWhenScrolling = false
        
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        navigationItem.searchController = search
    }
}

extension GithubRepoSearchViewController: GithubRepoSearchView {
    func showRecommended(_ data: [GithubRepoEntity]) {
        
    }
    
    func showData(_ data: [GithubRepoEntity]) {
        // TODO: 
    }
    
    func showError(_ error: Error) {
        
    }
}

extension GithubRepoSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        let text = searchController.searchBar.text ?? ""
        
        if !text.isEmpty {
            dependency.presenter.search(text)
        }
    }
}

extension GithubRepoSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //dependency.presenter.didSelect(GithubRepoEntity.init)
    }
}
