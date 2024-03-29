//
//  MockService.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation
import SwiftUI

/// - Note Mock server
class MockService: ApiServiceProtocol {
    @State private var charactersListModel = Bundle.main.decode(type: CharactersListModel.self, from: "MockJSON.json")
    func getAllCharaters() async throws -> CharactersListModel {
        return charactersListModel
    }
}
