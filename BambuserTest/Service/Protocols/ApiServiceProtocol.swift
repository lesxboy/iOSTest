//
//  ApiServiceProtocol.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

protocol ApiServiceProtocol {
    func getAllCharaters() async throws -> CharactersListModel
}
