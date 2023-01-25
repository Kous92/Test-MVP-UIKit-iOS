//
//  APIService.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 25/01/2023.
//

import Foundation

protocol APIService {
    func fetchDrivers() async throws -> [Driver]
}
