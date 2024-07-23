//
//  MoviesViewController.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import UIKit

class MoviesViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movies"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.isActive = true
    }

    func updateSearchResults(for searchController: UISearchController) {

    }

    @IBAction func pushDetail(_ sender: Any) {
        let destination = FavoritesViewController()
        destination.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destination, animated: true)
    }
}
