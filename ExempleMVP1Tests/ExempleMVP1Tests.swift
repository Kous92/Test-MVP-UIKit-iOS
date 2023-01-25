//
//  ExempleMVP1Tests.swift
//  ExempleMVP1Tests
//
//  Created by Koussaïla Ben Mamar on 25/01/2023.
//

import XCTest
@testable import ExempleMVP1

// On considère cette classe comme la vue pour tester la présentation (Presenter)
final class ExempleMVP1Tests: XCTestCase, PresenterViewDelegate {
    var presenter: Presenter!
    var expectation: XCTestExpectation?

    func testData() {
        expectation = expectation(description: "Fetch test data")
        setupFetchTest(error: false)
        
        waitForExpectations(timeout: 5)
        XCTAssertGreaterThan(presenter.drivers.count, 0)
    }
    
    func testFetchError() {
        expectation = expectation(description: "Fetch test error")
        setupFetchTest(error: true)
        
        waitForExpectations(timeout: 5)
        XCTAssertEqual(presenter.drivers.count, 0)
    }
    
    func testSearch() {
        expectation = expectation(description: "Search test")
        setupFetchTest(error: false)
        waitForExpectations(timeout: 5)
        presenter.searchDriver(with: "Lewis HAMILTON")
        XCTAssertEqual(presenter.drivers.count, 1)
    }
    
    private func setupFetchTest(error: Bool = false) {
        presenter = Presenter(with: MockAPIService(mockError: error))
        presenter.drivers.removeAll()
        presenter.setViewDelegate(delegate: self)
        presenter.fetchDriversData()
    }
    
    func didLoadData() {
        print("Vue actualisée")
        fulfillExpectation()
    }
    
    func didErrorOccured(with errorMessage: String) {
        print("Erreur: \(errorMessage)")
        fulfillExpectation()
    }
    
    /*
    Dans le cas d'une fonction déclenchée depuis une fonction asynchrone:
    1) Le test unitaire doit attendre un résultat avec une attente (expectation)
    2) Cette fonction ci-dessous confirme l'attente (méthode fulfill) pour vérifier l'assertion, dans le cas où la synchronisation des données est terminée
    3) Notamment dans le cas de plusieurs tests unitaires avec des attentes, une erreur se déclenche (NSInternalInconsistencyException: "API violation - multiple calls made to -[XCTestExpectation fulfill] for ...") si on ne définit pas la référence de l'expectation à nil.
    */
    private func fulfillExpectation() {
        expectation?.fulfill()
        expectation = nil
    }
}
