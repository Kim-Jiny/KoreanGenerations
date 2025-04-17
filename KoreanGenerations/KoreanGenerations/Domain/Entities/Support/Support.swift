//
//  Support.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/17/25.
//

import Foundation
struct Support: Codable {
    let supportYears: [Int]
    let dataVersion: String
    
    enum CodingKeys: String, CodingKey {
        case supportYears = "support_years"
        case dataVersion = "data_version"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.supportYears = try container.decodeIfPresent([Int].self, forKey: .supportYears) ?? []
        self.dataVersion = try container.decodeIfPresent(String.self, forKey: .dataVersion) ?? "1.0.0_beta"
    }
}
