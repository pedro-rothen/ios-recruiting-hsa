//
//  FavoritesCoordinator.swift
//  Movies
//
//  Created by Pedro on 25-07-24.
//

import UIKit

class FavoritesCoordinator: Coordinator {
    var navigationController: UINavigationController
    let getFavoritesUseCase: GetFavoritesUseCase
    let deleteFavoriteUseCase: DeleteFavoriteUseCase
    let getGenresUseCase: GetGenresUseCase

    init(navigationController: UINavigationController, 
         getFavoritesUseCase: GetFavoritesUseCase,
         deleteFavoriteUseCase: DeleteFavoriteUseCase,
         getGenresUseCase: GetGenresUseCase) {
        self.navigationController = navigationController
        self.getFavoritesUseCase = getFavoritesUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.getGenresUseCase = getGenresUseCase
    }

    func start() {
        let favoriteViewModel = FavoriteViewModel(
            getFavoritesUseCase: getFavoritesUseCase,
            deleteFavoriteUseCase: deleteFavoriteUseCase
        )
        let favoritesViewController = FavoritesViewController(
            viewModel: favoriteViewModel,
            favoritesCoordinator: self
        )
        navigationController.pushViewController(favoritesViewController, animated: false)
        navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: nil, tag: 1)
    }

    func showMovieDetail(movie: Movie) {
        showMovieDetail(movie: movie, getGenresUseCase: getGenresUseCase)
    }
}
