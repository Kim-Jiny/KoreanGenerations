//
//  Animation.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation

struct Animation: Codable {
    let title: String
    let startDate: String
    let endDate: String
    let posterUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case posterUrl = "poster_url"
        case startDate = "start_date"
        case endDate = "end_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.posterUrl = try container.decodeIfPresent(String.self, forKey: .posterUrl) ?? ""
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate) ?? ""
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate) ?? ""
    }
}
