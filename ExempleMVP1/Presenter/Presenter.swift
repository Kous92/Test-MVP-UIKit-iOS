//
//  Presenter.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 24/01/2023.
//

import Foundation

class Presenter {
    private var driversData = [Driver]()
    var drivers = [Driver]()
    private var errorMessage: String = ""
    private let apiService = APIService()
    
    // Référence avec la vue, attention à la rétention de cycle (memory leak)
    weak private var delegate: PresenterViewDelegate?
    
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
            
            updateView()
        }
    }
    
    func searchDriver(with driverName: String) {
        drivers = driverName.isEmpty ? driversData : driversData.filter { $0.name.lowercased().contains(driverName.lowercased()) }
        delegate?.didLoadData()
    }
    
    private func updateView() {
        DispatchQueue.main.async { [weak self] in
            guard (self?.drivers.count ?? 0) > 0 else {
                self?.delegate?.didErrorOccured(with: self?.errorMessage ?? "Une erreur est survenue")
                return
            }
            
            self?.delegate?.didLoadData()
        }
    }
}
