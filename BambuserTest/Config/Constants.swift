//
//  Constants.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation

enum Constants {
    ///Api
    static let host = "rickandmortyapi.com"
    static let path = "/api/character"
    static let scheme = "https"
    
    ///Keys
    static let darkModeKey = "isDarkMode"
    static let cacheKey = "allCharaters"
    
    ///Cache
    static let cacheInterval = 60.0
}
