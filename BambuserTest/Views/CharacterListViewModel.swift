//
//  CharacterListViewModel.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation
import Combine
import SwiftUI

enum DarkModeEnum: Int {
    case lightMode
    case darkMode
    
    func tag() -> Int {
        self.rawValue
    }
}

@MainActor
class CharacterListViewModel: ObservableObject {
    
    @AppStorage(Constants.darkModeKey, store: UserDefaults.shared) var isDarkMode: Bool?
    @Published var isLoading: Bool = false
    @Published var charatersList: [CharacterModel] = []
    @Published var error: NetworkError?
    @Published var searchText = ""
    @Published var darkModePicker = UserDefaults.standard.bool(forKey: Constants.darkModeKey) == true ? DarkModeEnum.darkMode.rawValue : DarkModeEnum.lightMode.rawValue
    
    private let service: ApiServiceProtocol
    private var anyCancellables = Set<AnyCancellable>()
    
    /// - Note Set cache to 60 sec
    private let cache = InMemoryCache<[CharacterModel]>(expirationInterval: Constants.cacheInterval)
    
    var searchResults: [CharacterModel] {
        if searchText.isEmpty {
            return charatersList
        } else {
            return charatersList.filter { $0.name.contains(searchText.trimmingCharacters(in: .whitespacesAndNewlines)) }
        }
    }
    
    init(service: ApiServiceProtocol = ApiService()){
        self.service = service
        configureListener()
    }
    
    // MARK: - Configure
    private func configureListener() {
        $darkModePicker
            .sink(receiveValue: { [weak self] mode in
                guard let _ = self else { return }
                UserDefaults.standard.set(DarkModeEnum(rawValue: mode) == .darkMode ? true : false, forKey: Constants.darkModeKey)
        }).store(in: &anyCancellables)
    }
    
    // MARK: - Fetch All Charaters from API
    func fetchAllCharaters() async throws {
        
        /// - Note check if list data is preserved in cache
        if let list = await cache.value(forKey: Constants.cacheKey) {
            charatersList = list
            isLoading = false
            return
        }
        
        do {
            isLoading = true
            let charactersList = try await service.getAllCharaters()
            charatersList = charactersList.results
            /// add list data to cache
            await cache.setValue(charactersList.results, forKey: Constants.cacheKey)
            isLoading = false
        } catch let apiError {
            error = apiError as? NetworkError
            isLoading = false
        }
    }
}
