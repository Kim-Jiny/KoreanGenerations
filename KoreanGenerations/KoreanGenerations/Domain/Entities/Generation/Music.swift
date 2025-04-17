//
//  Music.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation

struct Music: Codable {
    let title: String
    let artist: String
    let releaseDate: String
    let posterUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title, artist
        case releaseDate = "release_date"
        case posterUrl = "poster_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.artist = try container.decodeIfPresent(String.self, forKey: .artist) ?? ""
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.posterUrl = try container.decodeIfPresent(String.self, forKey: .posterUrl) ?? ""
    }
}
