//
//  GetFavoritesUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 24-07-24.
//

import Foundation
import Combine

class GetFavoritesUseCaseImpl: GetFavoritesUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute() -> AnyPublisher<[Movie], any Error> {
        return movieRepository.fetchFavorites()
    }
}
