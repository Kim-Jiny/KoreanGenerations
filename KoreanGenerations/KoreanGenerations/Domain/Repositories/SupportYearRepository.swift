//
//  SupportYearRepository.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/17/25.
//

import Foundation
import Combine

protocol SupportYearRepositoryProtocol {
    func fetchSupportYearData() -> AnyPublisher<Support, Error>
}

class SupportYearRepositoryImpl: SupportYearRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchSupportYearData() -> AnyPublisher<Support, Error> {
        let urlString = "https://raw.githubusercontent.com/Kim-Jiny/KoreanGenerations/refs/heads/main/data/supportData.json"
        
        return apiClient.request(url: urlString)
            .tryMap { data in
                // JSON 파싱
                let supportData = try JSONDecoder().decode(Support.self, from: data)
                return supportData
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
