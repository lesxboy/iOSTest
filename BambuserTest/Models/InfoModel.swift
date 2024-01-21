//
//  InfoModel.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

struct InfoModel: Codable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String?
}
