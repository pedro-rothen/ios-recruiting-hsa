//
//  GetGenresUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

class GetGenresUseCaseImpl: GetGenresUseCase {
    let movieRepository: MovieRepository

    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }

    func execute() -> AnyPublisher<[Genre], any Error> {
        return movieRepository.fetchGenres()
    }
}
