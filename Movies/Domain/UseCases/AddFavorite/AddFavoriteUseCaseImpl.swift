//
//  AddFavoriteUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 24-07-24.
//

import Foundation
import Combine

class AddFavoriteUseCaseImpl: AddFavoriteUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute(movie: Movie) -> AnyPublisher<Void, any Error> {
        return movieRepository.addFavorite(movie: movie)
    }
}
