//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import UIKit

class FavoritesViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.isHidden = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.isActive = true
    }

    func updateSearchResults(for searchController: UISearchController) {

    }
}
