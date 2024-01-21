//
//  CharactersListModel.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

struct CharactersListModel: Codable {
    let info: InfoModel
    let results: [CharacterModel]
}

extension CharactersListModel: Identifiable {
    var id: UUID {
        let id = UUID()
        return id
    }
}
