//
//  GetMoviesUseCaseImpl.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

// Should be at a separated file. Running out of time.
#if DEBUG
class UITestGetMoviesUseCaseImpl: GetMoviesUseCase {
    func execute(page: Int = 0) -> AnyPublisher<[Movie], Error> {
        return Just(MovieStub.movies)
            .setFailureType(to: Error.self)
            .delay(for: 2, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
#endif

class GetMoviesUseCaseImpl: GetMoviesUseCase {
    let moviesRepository: MovieRepository

    init(moviesRepository: MovieRepository) {
        self.moviesRepository = moviesRepository
    }

    func execute(page: Int = 0) -> AnyPublisher<[Movie], Error> {
        return moviesRepository.fetchMovies(page: page)
    }
}
