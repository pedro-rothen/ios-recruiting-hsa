//
//  MovieServiceImpl.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation
import Combine

class MovieServiceImpl: MovieService {
    let session: URLSessionProtocol
    private let baseUrl = "https://api.themoviedb.org/3/"

    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }

    func fetchMovies(page: Int) -> AnyPublisher<[Movie], any Error> {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = "movie/popular"
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
        ]
        guard let url = urlComponents?.url else {
            return Fail(error: MovieServiceError.badUrl).eraseToAnyPublisher()
        }

        let request = request(for: url)

        return session.dataTaskPublisher(request: request)
            .mapError { MovieServiceError.networkError($0) }
            .map(\.data)
            .decode(type: MovieResponse.self, decoder: JSONDecoder())
            .mapError { MovieServiceError.decodingError($0) }
            .map { $0.result }
            .eraseToAnyPublisher()
    }

    func fetchGenres() -> AnyPublisher<[Genre], any Error> {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.path = "genre/movie/list"
        guard let url = urlComponents?.url else {
            return Fail(error: MovieServiceError.badUrl).eraseToAnyPublisher()
        }

        let request = request(for: url)

        return session.dataTaskPublisher(request: request)
            .mapError { MovieServiceError.networkError($0) }
            .map(\.data)
            .decode(type: GenreResponse.self, decoder: JSONDecoder())
            .mapError { MovieServiceError.decodingError($0) }
            .map { $0.genres }
            .eraseToAnyPublisher()
    }

    private func request(for url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(Constants.MOVIEDB_TOKEN, forHTTPHeaderField: "Authorization")
        return request
    }
}

enum MovieServiceError: Error {
    case badUrl
    case networkError(Error)
    case decodingError(Error)
}


public protocol URLSessionProtocol {
    func dataTaskPublisher(url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
    func dataTaskPublisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

extension URLSession: URLSessionProtocol {
    public func dataTaskPublisher(url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return dataTaskPublisher(for: url)
            .eraseToAnyPublisher()
    }

    public func dataTaskPublisher(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        return dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}
