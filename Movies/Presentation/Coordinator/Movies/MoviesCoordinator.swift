//
//  MoviesCoordinator.swift
//  Movies
//
//  Created by Pedro on 25-07-24.
//

import UIKit

class MoviesCoordinator: Coordinator {
    var navigationController: UINavigationController
    let getMoviesUseCase: GetMoviesUseCase
    let getFavoritesUseCase: GetFavoritesUseCase
    let deleteFavoriteUseCase: DeleteFavoriteUseCase
    let addFavoriteUseCase: AddFavoriteUseCase
    let isFavoriteUseCase: IsFavoriteMovieUseCase
    let getGenresUseCase: GetGenresUseCase

    init(navigationController: UINavigationController, 
         getMoviesUseCase: GetMoviesUseCase,
         getFavoritesUseCase: GetFavoritesUseCase,
         deleteFavoriteUseCase: DeleteFavoriteUseCase,
         addFavoriteUseCase: AddFavoriteUseCase,
         isFavoriteUseCase: IsFavoriteMovieUseCase,
         getGenresUseCase: GetGenresUseCase) {
        self.navigationController = navigationController
        self.getMoviesUseCase = getMoviesUseCase
        self.getFavoritesUseCase = getFavoritesUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.addFavoriteUseCase = addFavoriteUseCase
        self.isFavoriteUseCase = isFavoriteUseCase
        self.getGenresUseCase = getGenresUseCase
    }

    func start() {
        let moviesViewModel = MoviesViewModel(
            getMoviesUseCase: getMoviesUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            deleteFavoriteUseCase: deleteFavoriteUseCase,
            isFavoriteMovieUseCase: isFavoriteUseCase
        )

        let moviesViewController = MoviesViewController(
            viewModel: moviesViewModel,
            moviesCoordinator: self
        )
        navigationController.pushViewController(moviesViewController, animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Movies", image: nil, tag: 0)
    }

    func showMovieDetail(movie: Movie) {
        showMovieDetail(movie: movie, getGenresUseCase: getGenresUseCase)
    }
}
