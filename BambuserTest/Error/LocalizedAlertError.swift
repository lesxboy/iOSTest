//
//  LocalizedAlertError.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI

struct LocalizedAlertError: LocalizedError {
    
    let underlyingError: Error
    var errorDescription: String?
    var recoverySuggestion: String?
    init?(error: NetworkError?) {
        
        guard let error else { return nil }
        
        recoverySuggestion = error.localizedDescription
        underlyingError = error
        
        switch error {
        case NetworkError.invalidResponse:
            errorDescription = "Network Error"
        case NetworkError.invalidUrl:
            errorDescription = "Url Error"
        case .invalidData:
            errorDescription = "Data Error"
        case .failedToDecodeResponse:
            errorDescription = "Decoding Error"
        }
    }
}
