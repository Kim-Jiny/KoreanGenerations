//
//  GenerationRepository.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//
import Foundation
import Combine

protocol GenerationRepositoryProtocol {
    func fetchGenerationData(for year: Int) -> AnyPublisher<Generation, Error>
}

class GenerationRepositoryImpl: GenerationRepositoryProtocol {
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchGenerationData(for year: Int) -> AnyPublisher<Generation, Error> {
        let urlString = "https://raw.githubusercontent.com/Kim-Jiny/KoreanGenerations/main/data/1900/\(year).json"
        
        return apiClient.request(url: urlString)
            .tryMap { data in
                // JSON 파싱
                let generation = try JSONDecoder().decode(Generation.self, from: data)
                return generation
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
