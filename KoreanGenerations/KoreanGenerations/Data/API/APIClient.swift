//
//  APIClient.swift
//  KoreanGenerations
//
//  Created by 김미진 on 4/16/25.
//
import Foundation
import Combine

protocol APIClientProtocol {
    func request(url: String) -> AnyPublisher<Data, Error>
}

class APIClient: APIClientProtocol {
    func request(url: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: NSError(domain: "Invalid URL", code: 400, userInfo: nil)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
