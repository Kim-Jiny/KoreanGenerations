//
//  Generation.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation
struct Generation: Codable {
    let year: Int
    let koreanAge: Int
    let internationalAge: Int
    let zodiac: String
    let generation: String
    let generationGroup: String
    let koreanCharacteristics: [String]
    let worldEvents: [Event]
    let koreaEvents: [Event]
    let popularMusic: [Music]
    let popularMovies: [Movie]
    let popularDramas: [Drama]
    let fashionTrends: [String]
    let kidsToys: [String]
    let technology: [String]
    let animation: [Animation]
    
    enum CodingKeys: String, CodingKey {
        case year, zodiac, generation
        case koreanAge = "korean_age"
        case internationalAge = "international_age"
        case generationGroup = "generation_group"
        case koreanCharacteristics = "korean_characteristics"
        case worldEvents = "world_events"
        case koreaEvents = "korea_events"
        case popularMusic = "popular_music"
        case popularMovies = "popular_movies"
        case popularDramas = "popular_dramas"
        case fashionTrends = "fashion_trends"
        case kidsToys = "kids_toys"
        case technology
        case animation
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = try container.decodeIfPresent(Int.self, forKey: .year) ?? 0
        self.koreanAge = try container.decodeIfPresent(Int.self, forKey: .koreanAge) ?? 0
        self.internationalAge = try container.decodeIfPresent(Int.self, forKey: .internationalAge) ?? 0
        self.zodiac = try container.decodeIfPresent(String.self, forKey: .zodiac) ?? ""
        self.generation = try container.decodeIfPresent(String.self, forKey: .generation) ?? ""
        self.generationGroup = try container.decodeIfPresent(String.self, forKey: .generationGroup) ?? ""
        self.koreanCharacteristics = try container.decodeIfPresent([String].self, forKey: .koreanCharacteristics) ?? []
        self.worldEvents = try container.decodeIfPresent([Event].self, forKey: .worldEvents) ?? []
        self.koreaEvents = try container.decodeIfPresent([Event].self, forKey: .koreaEvents) ?? []
        self.popularMusic = try container.decodeIfPresent([Music].self, forKey: .popularMusic) ?? []
        self.popularMovies = try container.decodeIfPresent([Movie].self, forKey: .popularMovies) ?? []
        self.popularDramas = try container.decodeIfPresent([Drama].self, forKey: .popularDramas) ?? []
        self.fashionTrends = try container.decodeIfPresent([String].self, forKey: .fashionTrends) ?? []
        self.kidsToys = try container.decodeIfPresent([String].self, forKey: .kidsToys) ?? []
        self.technology = try container.decodeIfPresent([String].self, forKey: .technology) ?? []
        self.animation = try container.decodeIfPresent([Animation].self, forKey: .animation) ?? []
    }
}
