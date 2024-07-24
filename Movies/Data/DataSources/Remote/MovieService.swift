//
//  MovieService.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

protocol MovieService {
    func fetchMovies(page: Int) -> AnyPublisher<[Movie], Error>
    func fetchGenres() -> AnyPublisher<[Genre], Error>
}
