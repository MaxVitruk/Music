//
//  Track.swift
//  Music-Test
//
//  Created by Max Vitruk on 5/4/19.
//  Copyright © 2019 Max Vitruk. All rights reserved.
//

import Foundation

public struct Track : Codable {
    let title : String
    let albumArtUrl : String
    let artist : String
    let trackId : String
    let duration : Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case albumArtUrl
        case artist
        case trackId = "id"
        case duration
    }
}
