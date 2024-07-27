//
//  GenreRepositoryImplTests.swift
//  MoviesTests
//
//  Created by Pedro on 27-07-24.
//

import XCTest
import Combine
@testable import Movies

final class GenreRepositoryImplTests: XCTestCase {
    var genreRepository: GenreRepositoryImpl!
    var mockRemoteDataSource: MockMovieServiceApi!
    var mockLocalDataSource: MockGenreLocalDataSource!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRemoteDataSource = MockMovieServiceApi()
        mockLocalDataSource = MockGenreLocalDataSource()
        genreRepository = GenreRepositoryImpl(
            remoteDataSource: mockRemoteDataSource,
            localDataSource: mockLocalDataSource
        )
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        mockRemoteDataSource = nil
        mockLocalDataSource = nil
        genreRepository = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
        super.tearDown()
    }

    func testReturnGenresSuccessfully() throws {
        // Arrange
        let genres = GenreStub.genres
        mockRemoteDataSource.genreStub = Just(genres)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()

        // Act
        var receivedGenres: [Genre]?
        var receivedError: Error?
        let expectation = expectation(
            description: "Repository returns genres from data source successfully"
        )
        genreRepository.getGenres()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let failure):
                    receivedError = failure
                    expectation.fulfill()
                }
            }, receiveValue: {
                receivedGenres = $0
            }).store(in: &cancellables)
        waitForExpectations(timeout: 1)

        //Assert
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedGenres)
        XCTAssertEqual(genres, receivedGenres)
    }

    // Dummy for required dependency
    class MockGenreLocalDataSource: GenreLocalDataSource {
        var saveStub: AnyPublisher<Void, Error>!
        var getGenresStub: AnyPublisher<[GenreEntity], Error>!
        var getGenresStubByIdsStub: AnyPublisher<[GenreEntity], Error>!

        func save(genres: [Genre]) -> AnyPublisher<Void, Error> {
            return saveStub
        }
        
        func getGenres() -> AnyPublisher<[GenreEntity], Error> {
            return getGenresStub
        }
        
        func getGenres(by ids: [Int]) -> AnyPublisher<[GenreEntity], Error> {
            getGenresStubByIdsStub
        }
    }
}
