//
//  Drama.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation

struct Drama: Codable {
    let title: String
    let broadcastNetwork: String
    let startDate: String
    let endDate: String
    let posterUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case broadcastNetwork = "broadcast_network"
        case startDate = "start_date"
        case endDate = "end_date"
        case posterUrl = "poster_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.broadcastNetwork = try container.decodeIfPresent(String.self, forKey: .broadcastNetwork) ?? ""
        self.startDate = try container.decodeIfPresent(String.self, forKey: .startDate) ?? ""
        self.endDate = try container.decodeIfPresent(String.self, forKey: .endDate) ?? ""
        self.posterUrl = try container.decodeIfPresent(String.self, forKey: .posterUrl) ?? ""
    }
}
