//
//  Presenter.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 24/01/2023.
//

import Foundation

final class Presenter {
    private var driversData = [Driver]()
    var drivers = [Driver]()
    private var errorMessage: String = ""
    private let apiService: APIService
    
    // Référence avec la vue, attention à la rétention de cycle (memory leak)
    weak private var delegate: PresenterViewDelegate?
    
    // Injection de dépendance pour le mock ou le service réseau
    init(with apiService: APIService) {
        self.apiService = apiService
    }
    
    func setViewDelegate(delegate: PresenterViewDelegate){
        self.delegate = delegate
    }
    
    func fetchDriversData() {
        Task {
            do {
                driversData = try await apiService.fetchDrivers()
                drivers = driversData
            } catch APIError.errorMessage(let message) {
                errorMessage = message
            }
            
            print("Data: \(drivers.count), errorMessage = \(errorMessage)")
            
            await updateView()
        }
    }
    
    func searchDriver(with driverName: String) {
        drivers = driverName.isEmpty ? driversData : driversData.filter { $0.name.lowercased().contains(driverName.lowercased()) }
        delegate?.didLoadData()
    }
    
    // @MainActor remplace DispatchQueue.main.async, mais doit être appelé avec await dans un bloc async.
    @MainActor private func updateView() {
        guard drivers.count > 0 else {
            delegate?.didErrorOccured(with: errorMessage)
            return
        }
        
        delegate?.didLoadData()
    }
}
