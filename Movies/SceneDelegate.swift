//
//  SceneDelegate.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)

        /// Sorry about the boilerplate mate. Though about a @Injected property wrapper, 
        /// but to keep the project as standard as possible went for manual injection.
        let movieRemoteDataSource = MovieServiceApiImpl()
        let movieLocalDataSource = FavoriteMovieLocalDataSourceImpl()
        let movieRepository = MovieRepositoryImpl(
            remoteDataSource: movieRemoteDataSource, localDataSource: movieLocalDataSource)
        let getMoviesUseCase = GetMoviesUseCaseImpl(moviesRepository: movieRepository)
        let getGenresUseCase = GetGenresUseCaseImpl(movieRepository: movieRepository)

        /// Another solution would be merge favorite operations in a FavoriteService,
        /// and then call the repository directly. But I already did write those usecases. so anyways it's better for abstraction.
        let getFavoritesUseCase = GetFavoritesUseCaseImpl(movieRepository: movieRepository)
        let deleteFavoriteUseCase = DeleteFavoriteUseCaseImpl(movieRepository: movieRepository)
        let addFavoriteUseCase = AddFavoriteUseCaseImpl(movieRepository: movieRepository)
        let isFavoriteUseCase = IsFavoriteMovieUseCaseImpl(movieRepository: movieRepository)

        /// Bear with me, MoviesViewController and FavoritesViewController needs to
        /// handle their own navigation in order to use the navigation search bar.
        /// Thought about an intermediate VC to handle and pass the queries but it felt hacky.
        let moviesCoordinator = MoviesCoordinator(
            navigationController: UINavigationController(),
            getMoviesUseCase: getMoviesUseCase,
            getFavoritesUseCase: getFavoritesUseCase,
            deleteFavoriteUseCase: deleteFavoriteUseCase,
            addFavoriteUseCase: addFavoriteUseCase,
            isFavoriteUseCase: isFavoriteUseCase,
            getGenresUseCase: getGenresUseCase
        )

        let favoritesCoordinator = FavoritesCoordinator(
            navigationController: UINavigationController(),
            getFavoritesUseCase: getFavoritesUseCase,
            deleteFavoriteUseCase: deleteFavoriteUseCase,
            getGenresUseCase: getGenresUseCase
        )

        let navigationController = UINavigationController()
        mainCoordinator = MainCoordinator(
            navigationController: navigationController,
            moviesCoordinator: moviesCoordinator,
            favoritesCoordinator: favoritesCoordinator
        )
        mainCoordinator?.start()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}
