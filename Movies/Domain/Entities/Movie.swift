//
//  Movie.swift
//  Movies
//
//  Created by Pedro on 23-07-24.
//

import Foundation

struct Movie: Identifiable, Decodable {
    let id: Int
    let title, overview, posterPath, releaseDate: String

    // This could be a MovieMapper if it gets too complex
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
    }
}
