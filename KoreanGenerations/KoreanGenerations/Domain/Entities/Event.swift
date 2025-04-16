//
//  Event.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation

struct Event: Codable {
    let event: String
    let date: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.event = try container.decodeIfPresent(String.self, forKey: .event) ?? ""
        self.date = try container.decodeIfPresent(String.self, forKey: .date) ?? ""
    }
}
