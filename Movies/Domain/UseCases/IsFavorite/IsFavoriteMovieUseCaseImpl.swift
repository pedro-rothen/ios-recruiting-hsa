//
//  IsFavoriteMovieUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 24-07-24.
//

import Foundation
import Combine

class IsFavoriteMovieUseCaseImpl: IsFavoriteMovieUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute(movie: Movie) -> AnyPublisher<Bool, Error> {
        return movieRepository.isFavorite(movie: movie)
    }
}
