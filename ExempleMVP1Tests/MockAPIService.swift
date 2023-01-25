//
//  MockAPIService.swift
//  ExempleMVP1Tests
//
//  Created by Koussaïla Ben Mamar on 25/01/2023.
//

import Foundation
@testable import ExempleMVP1

final class MockAPIService: APIService {
    // Pour simuler les cas d'erreurs
    var mockError = false
    
    init(mockError: Bool = false) {
        self.mockError = mockError
    }
    
    func fetchDrivers() async throws -> [Driver] {
        guard mockError == false else {
            throw APIError.errorMessage("Une erreur est survenue")
        }
        
        return [Driver(id: 1, name: "Lewis HAMILTON"), Driver(id: 2, name: "Michael SCHUMACHER"), Driver(id: 3, name: "Ayrton SENNA")]
    }
}
