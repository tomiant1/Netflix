//
//  Movie.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/28/22.
//

import Foundation

struct Response: Codable {
    
    let results: [Title]
    
}

struct Title: Codable {
    
    let id: Int
    let vote_count: Int
    let vote_average: Double
    let media_type: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let release_date: String?
    
}
