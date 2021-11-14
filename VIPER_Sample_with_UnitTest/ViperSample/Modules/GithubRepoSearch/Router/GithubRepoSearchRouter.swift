//
//  GithubRepoSearchRouter.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation

protocol GithubRepoSearchWireframe: AnyObject {
    func showNextView()
}

class GithubRepoSearchRouter: GithubRepoSearchWireframe {
    func showNextView() {
        print("showNextView!!!")
    }
}
