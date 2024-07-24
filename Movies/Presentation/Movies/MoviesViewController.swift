//
//  MoviesViewController.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import UIKit
import Combine

class MoviesViewController: UIViewController, UISearchResultsUpdating {
    let searchController = UISearchController()
    let viewModel: MoviesViewModel
    var cancellables = Set<AnyCancellable>()

    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

        viewModel.getMovies()
    }

    func setupBinding() {
        viewModel.$movies.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        }) {
            print($0)
        }.store(in: &cancellables)
    }

    func updateSearchResults(for searchController: UISearchController) {

    }

    @IBAction func pushDetail(_ sender: Any) {
        let destination = FavoritesViewController()
        destination.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(destination, animated: true)
    }
}

class MoviesViewModel {
    @Published var movies = [Movie]()
    private let getMoviesUseCase: GetMoviesUseCase
    var cancellables = Set<AnyCancellable>()

    init(getMoviesUseCase: GetMoviesUseCase) {
        self.getMoviesUseCase = getMoviesUseCase
    }

    func getMovies() {
//        getMoviesUseCase
//            .execute(page: 1)
//            .receive(on: DispatchQueue.main)
//            .replaceError(with: [])
//            .assign(to: &$movies)
        getMoviesUseCase
            .execute(page: 1)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            }) {
                print($0)
            }.store(in: &cancellables)
    }
}
