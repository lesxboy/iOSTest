//
//  Service.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

class Service: Servicing {
    
    private let networkService: NetworkServiceProtocol
    
    var apiUrlComponent: URLComponents {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        return components
    }
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getAllCharaters() async throws -> CharactersListModel {
        guard let url = apiUrlComponent.url else {
            throw NetworkError.invalidUrl
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return try await networkService.fetch(with: request)
    }
}
