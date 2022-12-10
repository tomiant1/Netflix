//
//  YoutubeSearchResponse.swift
//  Nextflix-Clone-App
//
//  Created by Tomi Antoljak on 11/30/22.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    
    let items: [VideoElement]
    
}

struct VideoElement: Codable {
    
    let id: VideoIdElement
    
}

struct VideoIdElement: Codable {
    
    let kind: String
    
    let videoId: String
}
