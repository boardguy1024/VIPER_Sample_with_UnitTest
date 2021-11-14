//
//  MainViewController.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    @IBAction private func buttonTapped(_ sender: Any) {
        
        let entryViewController = AppDefaultDependency().rootViewController()
        navigationController?.pushViewController(entryViewController, animated: true)
    }
}
