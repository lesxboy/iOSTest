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

    // MARK: - Test Fetch All CharatersList
   func test_characterListViewModel_getAllCharaters_shouldReturnAllCharaters() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithResult())
        
        // Act
        try? await viewModel.fetchAllCharaters()
        
        // Assert
        let expectedResult = Bundle.main.decode(type: CharactersListModel.self, from: "MockJSON.json")
        let result = viewModel.charatersList
        XCTAssertEqual(result, expectedResult.results, "Was: \(result), but should have been \(expectedResult)")
    }
    
    // MARK: - Test Service Errors
    func test_characterListViewModel_getAllCharaters_NetworkError_shouldReturnBadResponse() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithNetWorkError())
        
        // Act
        try? await viewModel.fetchAllCharaters()
        
        // Assert
        let expectedResult = NetworkError.invalidResponse
        let result = viewModel.error
        
        XCTAssertEqual(result, expectedResult, "Was: \(String(describing: result)), but should have been \(expectedResult)")
    }
    
    func test_characterListViewModel_getAllCharaters_NetworkError_shouldReturnBadUrl() async {
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestUrlComponentService())
        
        // Act
        try? await viewModel.fetchAllCharaters()
        
        // Assert
        let result = viewModel.error
        let expectedResult = NetworkError.invalidUrl
        
        XCTAssertEqual(result, expectedResult, "Was: \(String(describing: result)), but should have been \(expectedResult)")
    }
    
    // MARK: - Test Filter
    func test_characterListViewModel_searchText_filter_shouldReturnEmptyResult() async {
        
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithResult())
        
        // Act
        try? await viewModel.fetchAllCharaters()
        viewModel.searchText = "Test Test"

        // Assert
        let result = viewModel.searchResults
        XCTAssertTrue(result.isEmpty)
    }
    
    func test_characterListViewModel_searchText_filter_shouldReturnSearchResult() async {
        
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithResult())
        
        // Act
        try? await viewModel.fetchAllCharaters()
        viewModel.searchText = "Antenna"

        // Assert
        let result = viewModel.searchResults
        XCTAssertFalse(result.isEmpty)
    }
    
    // MARK: - Test Dark Mode Logic
    func test_characterListViewModel_darkMode_off_filter_shouldReturnDarkModeFalse() async {
        
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithNetWorkError())
        let lightModeTag: DarkModeEnum = .lightMode
        
        // Act
        viewModel.darkModePicker = lightModeTag.rawValue
        
        // Assert
        let result = UserDefaults.standard.bool(forKey: "isDarkMode")
        XCTAssertFalse(result)
    }
    
    func test_characterListViewModel_darkMode_on_filter_shouldReturnDarkModeTrue() async {
        
        // Arrange
        let viewModel = CharacterListViewModel(service: MockTestServiceWithNetWorkError())
        let darkModeTag: DarkModeEnum = .darkMode

        // Act
        viewModel.darkModePicker = darkModeTag.rawValue
        
        // Assert
        let result = UserDefaults.standard.bool(forKey: "isDarkMode")
        XCTAssertTrue(result)
    }
}

// MARK: - Mock UrlComponent Service
class MockTestUrlComponentService: Service {
    
    override var apiUrlComponent: URLComponents {
        var components = URLComponents()
        components.scheme = "xxx"
        components.host = "xxx"
        components.path = "xxx"
        return components
    }
}

// MARK: - Mock Error Service
class MockTestServiceWithNetWorkError: Servicing {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = MockNetworkService()) {
        self.networkService = networkService
    }
    
    func getAllCharaters() async throws -> CharactersListModel {
        throw NetworkError.invalidResponse
    }
}

// MARK: - Mock Service Return CharactersListModel's
class MockTestServiceWithResult: Servicing {
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = MockNetworkService()) {
        self.networkService = networkService
    }
    
    func getAllCharaters() async throws -> CharactersListModel {
        
        guard let url = URL(string: "test") else {
            throw NetworkError.invalidUrl
        }
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        return try await networkService.fetch(with: request)
    }
}


class MockNetworkService: NetworkServiceProtocol {
    
    @State private var charactersListModel = Bundle.main.decode(type: CharactersListModel.self, from: "MockJSON.json")
    
    func fetch<T: Decodable>(with request: URLRequest) async throws -> T {
        return charactersListModel as! T
    }
}
