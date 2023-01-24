//
//  APIError.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 24/01/2023.
//

import Foundation

enum APIError: Error {
    case errorMessage(String)
    
    var errorMessageString: String {
        switch self {
        case .errorMessage(let message):
            return message
        }
    }
}
