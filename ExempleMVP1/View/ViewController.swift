//
//  ViewController.swift
//  ExempleMVP1
//
//  Created by Koussaïla Ben Mamar on 23/01/2023.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Référence circulaire. Forte de la vue avec le présentateur, faible du présentateur vers la vue.
    private lazy var presenter = Presenter(with: NetworkAPIService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        presenter.setViewDelegate(delegate: self)
        presenter.fetchDriversData()
    }
    
    private func setViews() {
        tableView.dataSource = self
        tableView.isHidden = true
        loadingSpinner.hidesWhenStopped = true
        loadingSpinner.startAnimating()
        setSearchBar()
    }
    
    private func setSearchBar() {
        // Configuration barre de recherche
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .label
        searchBar.backgroundImage = UIImage() // Supprimer le fond par défaut
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
}

// En MVP, la mise à jour se fait avec le pattern de la délégation
extension ViewController: PresenterViewDelegate {
    func didLoadData() {
        loadingSpinner.stopAnimating()
        tableView.reloadData()
        tableView.isHidden = false
    }
    
    func didErrorOccured(with errorMessage: String) {
        let alert = UIAlertController(title: "Erreur", message: errorMessage, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
             print("OK")
        }))

        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.drivers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = presenter.drivers[indexPath.row].name
        
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true) // Afficher le bouton d'annulation
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchDriver(with: searchText)
    }
}
