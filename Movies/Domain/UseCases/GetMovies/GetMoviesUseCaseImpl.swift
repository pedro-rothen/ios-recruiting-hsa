//
//  GetMoviesUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    let moviesRepository: MovieRepository

    init(moviesRepository: MovieRepository) {
        self.moviesRepository = moviesRepository
    }

    func execute(page: Int = 0) -> AnyPublisher<[Movie], Error> {
        return moviesRepository.fetchMovies(page: page)
    }
}
