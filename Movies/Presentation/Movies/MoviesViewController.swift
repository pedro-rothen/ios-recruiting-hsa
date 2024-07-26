//
//  MoviesViewController.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import UIKit
import Combine
import Kingfisher

class MoviesViewController: UIViewController, UISearchResultsUpdating {
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelNoResults: UILabel!
    @IBOutlet weak var buttonRetry: UIButton!

    let searchController = UISearchController()
    let viewModel: MoviesViewModel
    var cancellables = Set<AnyCancellable>()
    let movieCellId = "cell"
    weak var coordinator: MoviesCoordinator?

    init(viewModel: MoviesViewModel, moviesCoordinator: MoviesCoordinator) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        coordinator = moviesCoordinator
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

        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: movieCellId)
        moviesCollectionView.dataSource = self
        moviesCollectionView.delegate = self

        setupBindings()

        viewModel.getMovies()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateVisibleCells()
    }

    func updateVisibleCells() {
        for cell in moviesCollectionView.visibleCells {
            if let indexPath = moviesCollectionView.indexPath(for: cell),
               let movieCell = cell as? MovieCollectionViewCell,
               let movie = viewModel.movies?[indexPath.row] {
                viewModel.isFavorite(movie: movie) { [weak movieCell] in
                    movieCell?.bindFavoriteIcon(isFavorite: $0)
                }
            }
        }
    }

    func setupBindings() {
        viewModel
            .$uiState
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] uiState in
                guard let self else { return }
                buttonRetry.isHidden = true
                labelNoResults.isHidden = true
                activityIndicator.isHidden = true
                moviesCollectionView.isHidden = true
                switch uiState {
                case .idle:
                    break
                case .loading:
                    activityIndicator.isHidden = false
                case .error:
                    buttonRetry.isHidden = false
                case .noResults:
                    labelNoResults.isHidden = false
                case .success:
                    moviesCollectionView.isHidden = false
                }
            }.store(in: &cancellables)
        viewModel
            .$movies
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.moviesCollectionView.reloadData()
            }.store(in: &cancellables)
    }

    func updateSearchResults(for searchController: UISearchController) {

    }

    @IBAction func pushDetail(_ sender: Any) {
//        let destination = FavoritesViewController()
//        destination.hidesBottomBarWhenPushed = true
//        navigationController?.pushViewController(destination, animated: true)
    }

    @IBAction func buttonRetryTapped(_ sender: Any) {
        viewModel.getMovies()
    }
}

extension MoviesViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate,
                                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: movieCellId,
            for: indexPath
        ) as? MovieCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let movie = viewModel.movies?[safe: indexPath.row], 
            let url = URL(string: Constants.MOVIEDBIMAGEURL + "\(movie.posterPath)") {
            cell.posterImageView.kf.setImage(with: url)
            cell.titleLabel.text = movie.title
            cell.toggleFavoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
            cell.delegate = self
            viewModel.isFavorite(movie: movie) { [weak cell] isFavorite in
                cell?.bindFavoriteIcon(isFavorite: isFavorite)
            }
        }
        return cell
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = width * 1.2
        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let movie = viewModel.movies?[indexPath.row] {
            coordinator?.showMovieDetail(movie: movie)
        }
    }
}

extension MoviesViewController: MovieCollectionViewCellDelegate {
    func toggleFavorite(for cell: MovieCollectionViewCell) {
        if let indexPath = moviesCollectionView.indexPath(for: cell),
           let movie = viewModel.movies?[safe: indexPath.row] {
            viewModel.toggleFavorite(for: movie) { [weak cell] isFavorite in
                cell?.bindFavoriteIcon(isFavorite: isFavorite)
            }
        }
    }
}

class MoviesViewModel {
    private let getMoviesUseCase: GetMoviesUseCase
    private let addFavoriteUseCase: AddFavoriteUseCase
    private let deleteFavoriteUseCase: DeleteFavoriteUseCase
    private let isFavoriteMovieUseCase: IsFavoriteMovieUseCase
    var cancellables = Set<AnyCancellable>()

    @Published var movies: [Movie]?
    @Published var uiState: MovieUiState = .idle

    init(getMoviesUseCase: GetMoviesUseCase,
         addFavoriteUseCase: AddFavoriteUseCase,
         deleteFavoriteUseCase: DeleteFavoriteUseCase,
         isFavoriteMovieUseCase: IsFavoriteMovieUseCase) {
        self.getMoviesUseCase = getMoviesUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.isFavoriteMovieUseCase = isFavoriteMovieUseCase
    }

    func getMovies() {
        uiState = .loading
        getMoviesUseCase
            .execute(page: 1)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                    self?.uiState = .error
                }
            }, receiveValue: { [weak self] in
                self?.uiState = .success
                self?.movies = $0
            }).store(in: &cancellables)
    }

    func isFavorite(movie: Movie, completion: @escaping (Bool) -> Void) {
        isFavoriteMovieUseCase
            .execute(movie: movie)
            .replaceError(with: false)
            .map { $0 }
            .sink {
                completion($0)
            }.store(in: &cancellables)
    }

    func toggleFavorite(for movie: Movie, completion: @escaping (Bool) -> Void) {
        var newValue = false
        isFavoriteMovieUseCase
            .execute(movie: movie)
            .flatMap { [deleteFavoriteUseCase, addFavoriteUseCase] isFavorite in
                newValue = !isFavorite
                return isFavorite ? 
                deleteFavoriteUseCase.execute(
                    movie: movie
                ) : addFavoriteUseCase.execute(
                    movie: movie
                )
            }.sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    print(failure)
                }
            }, receiveValue: {
                completion(newValue)
            }).store(in: &cancellables)
    }
}

enum MovieUiState {
    case idle, loading, error, noResults, success
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
