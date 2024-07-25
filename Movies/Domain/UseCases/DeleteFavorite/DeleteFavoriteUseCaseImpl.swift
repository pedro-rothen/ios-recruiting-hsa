//
//  DeleteFavoriteUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 24-07-24.
//

import Foundation
import Combine

class DeleteFavoriteUseCaseImpl: DeleteFavoriteUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute(movie: Movie) -> AnyPublisher<Void, any Error> {
        return movieRepository.deleteFavorite(movie: movie)
    }
}
