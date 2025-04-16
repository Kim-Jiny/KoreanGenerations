//
//  GenerationUseCase.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation
import Combine

protocol GenerationUseCaseProtocol {
    func getGenerationData(for year: Int) -> AnyPublisher<Generation, Error>
}

class GenerationUseCaseImpl: GenerationUseCaseProtocol {
    private let generationRepository: GenerationRepositoryProtocol
    
    init(generationRepository: GenerationRepositoryProtocol) {
        self.generationRepository = generationRepository
    }
    
    func getGenerationData(for year: Int) -> AnyPublisher<Generation, Error> {
        return generationRepository.fetchGenerationData(for: year)
    }
}
