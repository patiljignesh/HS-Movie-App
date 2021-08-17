//
//  Movie.swift
//  HS Movie App
//
//  Created by Jigneshkumar Patil on 2021/08/15.
//

import Foundation

struct MovieData: Codable {
    let results : [Results]
}

struct Results: Codable {
    let id: Int
    let title: String
    let release_date: String
    let vote_average: Double
    let poster_path: String
}
