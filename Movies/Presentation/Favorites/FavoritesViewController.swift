//
//  FavoritesViewController.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import UIKit
import Combine
import Kingfisher

class FavoritesViewController: UIViewController, UISearchResultsUpdating {
    let viewModel: FavoriteViewModel
    let cellId = "cell"
    let searchController = UISearchController()
    var cancellables = Set<AnyCancellable>()
    var favoriteMoviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    var notResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No results"
        return label
    }()

    init(viewModel: FavoriteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = UIView()
        view.addSubview(favoriteMoviesTableView)
        NSLayoutConstraint.activate([
            favoriteMoviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteMoviesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteMoviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteMoviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

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

        favoriteMoviesTableView.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: cellId)
        favoriteMoviesTableView.rowHeight = UITableView.automaticDimension
        favoriteMoviesTableView.dataSource = self
        favoriteMoviesTableView.delegate = self

        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getFavoriteMovies()
    }

    func setupBindings() {
        viewModel
            .$favoritesMovies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.favoriteMoviesTableView.reloadData()
            }.store(in: &cancellables)
    }

    func updateSearchResults(for searchController: UISearchController) {

    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favoritesMovies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: cellId,
            for: indexPath
        ) as? FavoriteMovieTableViewCell else {
            return UITableViewCell()
        }
        if let movie = viewModel.favoritesMovies?[safe: indexPath.row],
            let url = URL(string: Constants.MOVIEDBIMAGEURL + "\(movie.posterPath)") {
            cell.posterImageView.kf.setImage(with: url)
            cell.titleLabel.text = movie.title
            cell.releaseYearLabel.text = movie.releaseDate
            cell.overviewLabel.text = movie.overview
        }
        return cell
    }
}

class FavoriteViewModel {
    private let getFavoritesUseCase: GetFavoritesUseCase
    private let deleteFavoriteUseCase: DeleteFavoriteUseCase
    private var cancellables = Set<AnyCancellable>()

    @Published var favoritesMovies: [Movie]?

    init(getFavoritesUseCase: GetFavoritesUseCase, deleteFavoriteUseCase: DeleteFavoriteUseCase) {
        self.getFavoritesUseCase = getFavoritesUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
    }

    func getFavoriteMovies() {
        getFavoritesUseCase
            .execute()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: { [weak self] movies in
                self?.favoritesMovies = movies
            }).store(in: &cancellables)
    }
}
