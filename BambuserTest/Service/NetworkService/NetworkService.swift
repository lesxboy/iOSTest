//
//  NetworkService.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-22.
//

import Foundation

final class NetworkService: NetworkServiceProtocol {
    
    func fetch<T: Decodable>(with request: URLRequest) async throws -> T {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
}
