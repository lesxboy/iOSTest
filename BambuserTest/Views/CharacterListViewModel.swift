//
//  CharacterListViewModel.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class CharacterListViewModel: ObservableObject {
    
    @AppStorage(Constants.darkModeKey,store: UserDefaults.shared) var isDarkMode: Bool?
    @Published var isLoading: Bool = false
    @Published var charatersList: [CharacterModel] = []
    @Published var error: NetworkError?
    @Published var searchText = ""
    @Published var darkModePicker = UserDefaults.standard.bool(forKey: Constants.darkModeKey) == true ? 1 : 0
    
    private let service: Servicing
    private var anyCancellables = Set<AnyCancellable>()
    
    /// Set cache to 60 sec
    private let cache = InMemoryCache<[CharacterModel]>(expirationInterval: Constants.cacheInterval)
    
    var searchResults: [CharacterModel] {
        if searchText.isEmpty {
            return charatersList
        } else {
            return charatersList.filter { $0.name.contains(searchText.trimmingCharacters(in: .whitespacesAndNewlines)) }
        }
    }
    
    init(service: Servicing){
        self.service = service
        configureListener()
    }
    
    private func configureListener() {
        $darkModePicker
            .sink(receiveValue: { [weak self] mode in
                guard let _ = self else { return }
                UserDefaults.standard.set(mode == 1 ? true : false, forKey: Constants.darkModeKey)
        }).store(in: &anyCancellables)
    }
    
    func getAllCharaters() async throws {
        
        /// check if list data is preserved in cache
        if let list = await cache.value(forKey: Constants.cacheKey) {
            ///Load list from cache
            charatersList = list
            isLoading = false
            return
        }
        
        do {
            isLoading = true
            let charactersList = try await service.getAllCharaters()
            charatersList = charactersList.results
            isLoading = false
            
            /// add list data to cache
            await cache.setValue(charactersList.results, forKey: Constants.cacheKey)
        } catch let apiError {
            error = apiError as? NetworkError
            isLoading = false
        }
    }
}
