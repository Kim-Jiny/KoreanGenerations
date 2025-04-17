//
//  GenerationViewModel.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//

import Foundation
import Combine

class GenerationViewModel: ObservableObject {
    private let generationUseCase: GenerationUseCaseProtocol
    private let supportUseCase: SupportUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var generation: Generation?
    @Published var isLoading = false
    @Published var error: Error?
    @Published var supportYears: [Int] = []
    @Published var dataVersion: String = ""
    
    init(useCase: GenerationUseCaseProtocol, supportUseCase: SupportUseCaseProtocol) {
        self.generationUseCase = useCase
        self.supportUseCase = supportUseCase
    }
    
    func fetchSupportYears() {
        supportUseCase.getSupportYearData()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    DispatchQueue.main.async {
                        print("지원 연도를 가지고오는데 실패했습니다.")
                    }
                case .finished:
                    break
                }
            }, receiveValue: { support in
                DispatchQueue.main.async {
                    self.supportYears = support.supportYears
                    self.dataVersion = support.dataVersion
                }
            })
            .store(in: &cancellables)
    }
    
    func loadGenerationData(for year: Int) {
        isLoading = true
        generationUseCase.getGenerationData(for: year)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let err):
                    DispatchQueue.main.async {
                        self.error = err
                        self.generation = nil
                    }
                case .finished:
                    break
                }
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }, receiveValue: { generation in
                DispatchQueue.main.async {
                    self.error = nil
                    self.generation = generation
                }
            })
            .store(in: &cancellables)
    }
    
    func calculateInternationalAge(from birthYear: Int) -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return max(0, currentYear - birthYear)
    }

    func calculateKoreanAge(from birthYear: Int) -> Int {
        let currentYear = Calendar.current.component(.year, from: Date())
        return max(1, currentYear - birthYear + 1)
    }
}
