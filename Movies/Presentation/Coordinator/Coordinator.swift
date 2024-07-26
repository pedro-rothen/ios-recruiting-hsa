//
//  Coordinator.swift
//  Movies
//
//  Created by Pedro on 25-07-24.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

extension Coordinator {
    func showMovieDetail(
        movie: Movie,
        getGenresUseCase: GetGenresUseCase) {
            let detailViewController = MovieDetailViewController(
                movie: movie,
                getGenresUseCase: getGenresUseCase
            )
            detailViewController.hidesBottomBarWhenPushed = true
            navigationController.pushViewController(
                detailViewController,
                animated: true
        )
    }
}
