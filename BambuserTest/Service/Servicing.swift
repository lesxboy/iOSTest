//
//  Servicing.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

protocol Servicing{
    func getAllCharaters() async throws -> CharactersListModel
}
