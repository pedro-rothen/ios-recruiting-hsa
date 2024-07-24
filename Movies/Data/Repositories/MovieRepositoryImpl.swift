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
    //let localDataSource

    init(remoteDataSource: MovieService) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error> {
        return remoteDataSource.fetchMovies(page: page)
    }
    
    func fetchGenres() -> AnyPublisher<[Genre], Error> {
        return remoteDataSource.fetchGenres()
    }

    func fetchFavorites() -> AnyPublisher<[Movie], Error> {
        return Just([]).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func addFavorite(movie: Movie) -> AnyPublisher<Void, Error> {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func deleteFavorite(movie: Movie) -> AnyPublisher<Void, Error> {
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
