//
//  GithubAPIError.swift
//  VIPER_Sample_with_UnitTest
//
//  Created by park kyung seok on 2021/11/14.
//

import Foundation

enum GithubAPIError: Error, LocalizedError {
    case lateLimit
    
    var errorDescription: String? {
        switch self {
        case .lateLimit:
            return "API rate limit exceeded."
        }
    }
}
