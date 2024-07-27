//
//  GenreLocalDataSourceImplTests.swift
//  MoviesTests
//
//  Created by Pedro on 27-07-24.
//

import XCTest
import CoreData
import Combine
@testable import Movies

final class GenreLocalDataSourceImplTests: XCTestCase {
    var genreLocalDataSource: GenreLocalDataSourceImpl!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        genreLocalDataSource = GenreLocalDataSourceImpl(
            context: InMemoryController().context
        )
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        genreLocalDataSource = nil
        cancellables.forEach { $0.cancel() }
        cancellables = nil
        super.tearDown()
    }

    func testWriteGenresToStorageSuccessfully() throws {
        // Arrange
        let domainGenres = GenreStub.genres.sorted { $0.id < $1.id }

        // Act
        let saveExpectation = expectation(description: "Genres are saved to storage successfully")
        var receivedError: Error?
        var receivedDomainGenre: [Genre]?
        genreLocalDataSource
            .save(genres: domainGenres)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    saveExpectation.fulfill()
                case .failure(let failure):
                    receivedError = failure
                    saveExpectation.fulfill()
                }
            }, receiveValue: { })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1)

        let fetchExpectation = expectation(description: "Genres are fetch from storage successfully")
        genreLocalDataSource
            .getGenres()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    fetchExpectation.fulfill()
                case .failure(let failure):
                    XCTFail(failure.localizedDescription)
                }
            }, receiveValue: {
                receivedDomainGenre = $0.compactMap { $0.toDomain}
            }).store(in: &cancellables)
        waitForExpectations(timeout: 1)

        // Assert
        XCTAssertNil(receivedError)
        XCTAssertNotNil(receivedDomainGenre)

        let sortedReceivedDomainGenres = receivedDomainGenre?.sorted { $0.id < $1.id }
        XCTAssertEqual(sortedReceivedDomainGenres, domainGenres)
    }
}

class InMemoryController {
    let container: NSPersistentContainer
    var context: NSManagedObjectContext {
        return container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: "Movies")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Error while loading persistence storage \(error)")
            }
        }
    }
}
