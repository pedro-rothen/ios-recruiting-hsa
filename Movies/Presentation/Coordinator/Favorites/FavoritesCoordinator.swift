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
    let getGenresByIdsUseCase: GetGenresByIdsUseCase

    init(navigationController: UINavigationController, 
         getFavoritesUseCase: GetFavoritesUseCase,
         deleteFavoriteUseCase: DeleteFavoriteUseCase,
         getGenresByIdsUseCase: GetGenresByIdsUseCase) {
        self.navigationController = navigationController
        self.getFavoritesUseCase = getFavoritesUseCase
        self.deleteFavoriteUseCase = deleteFavoriteUseCase
        self.getGenresByIdsUseCase = getGenresByIdsUseCase
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
        navigationController.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart"), tag: 1)
    }

    func showMovieDetail(movie: Movie) {
        showMovieDetail(movie: movie, getGenresByIdsUseCase: getGenresByIdsUseCase)
    }
}
