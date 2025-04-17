//
//  Movie.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation

struct Movie: Codable {
    let krTitle: String
    let enTitle: String
    let country: String
    let releaseDate: String
    let posterUrl: String
    
    enum CodingKeys: String, CodingKey {
        case country
        case krTitle = "kr_title"
        case enTitle = "en_title"
        case releaseDate = "release_date"
        case posterUrl = "poster_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        self.krTitle = try container.decodeIfPresent(String.self, forKey: .krTitle) ?? ""
        self.enTitle = try container.decodeIfPresent(String.self, forKey: .enTitle) ?? ""
        self.releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        self.posterUrl = try container.decodeIfPresent(String.self, forKey: .posterUrl) ?? ""
    }
}
