//
//  NetworkError.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

enum NetworkError: String, LocalizedError {
    case badUrl = "Invalid URL"
    case badResponse = "No Response"
    case invalidData = "Data corrupt"
    case failedToDecodeResponse = "Failed to decode response"
    var localizedDescription: String { return NSLocalizedString(self.rawValue, comment: "") }
}
