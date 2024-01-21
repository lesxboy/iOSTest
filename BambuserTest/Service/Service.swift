//
//  Service.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

class Service: Servicing {
    
     var apiUrlComponent: URLComponents {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        return components
    }
    
    func getAllCharaters() async throws -> CharactersListModel {
        
        guard let url = apiUrlComponent.url else {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(CharactersListModel.self, from: data)
            return decoded
        } catch {
            throw NetworkError.failedToDecodeResponse
        }
    }
}
