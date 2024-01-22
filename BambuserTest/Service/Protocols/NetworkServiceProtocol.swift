//
//  NetworkServiceProtocol.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-22.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(with request: URLRequest) async throws -> T
}
