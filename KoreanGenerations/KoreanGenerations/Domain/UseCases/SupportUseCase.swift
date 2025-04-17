//
//  SupportUseCase.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/17/25.
//

import Foundation
import Combine

protocol SupportUseCaseProtocol {
    func getSupportYearData() -> AnyPublisher<Support, Error>
}

class SupportUseCaseImpl: SupportUseCaseProtocol {
    private let supportYearRepository: SupportYearRepositoryProtocol
    
    init(supportYearRepository: SupportYearRepositoryProtocol) {
        self.supportYearRepository = supportYearRepository
    }
    
    func getSupportYearData() -> AnyPublisher<Support, Error> {
        return supportYearRepository.fetchSupportYearData()
    }
}
