//
//  BambuserTestTests.swift
//  BambuserTestTests
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI
import XCTest
@testable import BambuserTest

@MainActor
final class BambuserViewModelTest: XCTestCase {
    
    // Test Fetch CharatersList
   func test_characterListViewModel_getAllCharaters_shouldReturnAllCharaters() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestService())
        
        // Act
        try? await viewModel.getAllCharaters()
        
        // Assert
        let expectedResult = Bundle.main.decode(type: CharactersListModel.self, from: "MockJSON.json")
        let result = viewModel.charatersList
        XCTAssertEqual(result, expectedResult.results, "Was: \(result), but should have been \(expectedResult)")
    }
    
    // Test Errors
    func test_characterListViewModel_getAllCharaters_NetworkError_shouldReturnBadResponse() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithNetWorkError())
        
        // Act
        try? await viewModel.getAllCharaters()
        
        // Assert
        let expectedResult = NetworkError.badResponse
        let result = viewModel.error
        
        XCTAssertEqual(result, expectedResult, "Was: \(String(describing: result)), but should have been \(expectedResult)")
    }
    
    
    func test_characterListViewModel_getAllCharaters_NetworkError_shouldReturnBadUrl() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestUrlComponentService())
        
        // Act
        try? await viewModel.getAllCharaters()
        
        // Assert
        let result = viewModel.error
        let expectedResult = NetworkError.badUrl
        
        XCTAssertEqual(result, expectedResult, "Was: \(String(describing: result)), but should have been \(expectedResult)")
    }
    
    // Test Filter
    func test_characterListViewModel_searchText_filter_shouldReturnEmptyResult() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestService())
        
        // Act
        try? await viewModel.getAllCharaters()
        viewModel.searchText = "Test Test"

        // Assert
        let result = viewModel.searchResults
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_characterListViewModel_searchText_filter_shouldReturnSearchResult() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestService())
        
        // Act
        try? await viewModel.getAllCharaters()
        viewModel.searchText = "Antenna"

        // Assert
        let result = viewModel.searchResults
        XCTAssertFalse(result.isEmpty)
    }
    
    // Test Dark Mode Logic
    
    func test_characterListViewModel_darkMode_off_filter_shouldReturnDarkModeFalse() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestService())
        
        // Act
        viewModel.darkMode = 0
        
        // Assert
        let result = UserDefaults.standard.bool(forKey: "isDarkMode")
        XCTAssertFalse(result)
    }
    
    func test_characterListViewModel_darkMode_on_filter_shouldReturnDarkModeTrue() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestService())
        
        // Act
        viewModel.darkMode = 1
        
        // Assert
        let result = UserDefaults.standard.bool(forKey: "isDarkMode")
        XCTAssertTrue(result)
    }
}

/// Mock UrlComponent Service
class MockTestUrlComponentService: Service {
    override var apiUrlComponent: URLComponents {
        var components = URLComponents()
        components.scheme = "xxx"
        components.host = "xxx"
        components.path = "xxx"
        return components
    }
}

/// Mock Service
class MockTestService: Servicing {
    @State private var charactersListModel = Bundle.main.decode(type: CharactersListModel.self, from: "MockJSON.json")
    func getAllCharaters() async throws -> CharactersListModel {
        return charactersListModel
    }
}

/// Mock Error Service
class MockTestServiceWithNetWorkError: Servicing {
    @State private var charactersListModel = Bundle.main.decode(type: CharactersListModel.self, from: "MockJSON.json")
    func getAllCharaters() async throws -> CharactersListModel {
        throw NetworkError.badResponse
    }
}
