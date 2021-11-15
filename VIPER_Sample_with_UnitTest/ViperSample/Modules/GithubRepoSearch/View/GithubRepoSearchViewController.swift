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

    private let displayData = GithubRepoViewData()
    
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
        displayData.recommends = data
        tableView.reloadData()
    }
    
    func showData(_ data: [GithubRepoEntity]) {
        displayData.searchResultEntities = data
        tableView.reloadData()
    }
    
    func showError(_ error: Error) {
        // TODO: showError
        print("showed Error: \(error)")
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

extension GithubRepoSearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        displayData.numberOfSEctions
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayData.numberOfItems(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let entity = displayData.item(with: indexPath)!
        
        if let stargazersCount = entity.stargazersCount {
            cell.textLabel?.text = "\(entity.name) ⭐️\(stargazersCount)"
        } else {
            cell.textLabel?.text = "\(entity.name)"
        }
        
        cell.detailTextLabel?.text = entity.description
        return cell
    }
}

extension GithubRepoSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = displayData.item(with: indexPath)!
        dependency.presenter.didSelect(entity)
    }
}
