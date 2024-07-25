//
//  MovieRepositoryImpl.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

class MovieRepositoryImpl: MovieRepository {
    let remoteDataSource: MovieService
    let localDataSource: FavoriteMovieLocalDataSource

    init(remoteDataSource: MovieService, localDataSource: FavoriteMovieLocalDataSource) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        return remoteDataSource.fetchMovies(page: page)
    }
    
    func fetchGenres() -> AnyPublisher<[Genre], Error> {
        return remoteDataSource.fetchGenres()
    }

    func fetchFavorites() -> AnyPublisher<[Movie], Error> {
        return localDataSource
            .fetchFavorites()
            .map {
                $0.compactMap { $0.toDomain }
            }
            .eraseToAnyPublisher()
    }

    func addFavorite(movie: Movie) -> AnyPublisher<Void, Error> {
        return localDataSource.addFavorite(movie: movie).eraseToAnyPublisher()
    }

    func deleteFavorite(movie: Movie) -> AnyPublisher<Void, Error> {
        return localDataSource.deleteFavorite(movie: movie).eraseToAnyPublisher()
    }

    func isFavorite(movie: Movie) -> AnyPublisher<Bool, Error> {
        return localDataSource.isFavorite(movie: movie)
    }
}
