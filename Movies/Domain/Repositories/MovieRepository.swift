//
//  MovieRepository.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

protocol MovieRepository {
    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func fetchGenres() -> AnyPublisher<[Genre], Error>
    func fetchFavorites() -> AnyPublisher<[Movie], Error>
    func addFavorite(movie: Movie) -> AnyPublisher<Void, Error>
    func deleteFavorite(movie: Movie) -> AnyPublisher<Void, Error>
    func isFavorite(movie: Movie) -> AnyPublisher<Bool, Error>
}
