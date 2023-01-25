//
//  NetworkAPIService.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 24/01/2023.
//

import Foundation

final class NetworkAPIService: APIService {
    private let endpointURL: String
    
    init() {
        self.endpointURL = "https://my-json-server.typicode.com/kous92/Formula1-data-test-json/drivers"
    }
    
    func fetchDrivers() async throws -> [Driver] {
        guard let url = URL(string: endpointURL) else {
            print("URL invalide.")
            throw APIError.errorMessage("URL invalide.")
        }
            
        let (data, response) = try await URLSession.shared.data(from: url)
        print(url.absoluteString)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.errorMessage("Pas de réponse du serveur.")
        }
        
        guard httpResponse.statusCode == 200 else {
            print("Erreur code \(httpResponse.statusCode).")
            throw APIError.errorMessage("Erreur code \(httpResponse.statusCode).")
        }
        
        print("Code: \(httpResponse.statusCode)")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        var driversData = [Driver]()
        
        do {
            driversData = try decoder.decode([Driver].self, from: data)
        } catch {
            throw APIError.errorMessage("Erreur lors du décodage.")
        }
        
        guard !driversData.isEmpty else {
            print("Aucune donnée disponible).")
            throw APIError.errorMessage("Aucune donnée disponible.")
        }
        
        return driversData
    }
}
