//
//  PresenterViewDelegate.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 24/01/2023.
//

import Foundation

protocol PresenterViewDelegate: AnyObject {
    func didLoadData()
    func didErrorOccured(with errorMessage: String)
}
