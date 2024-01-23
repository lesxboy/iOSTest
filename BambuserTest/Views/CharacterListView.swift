//
//  CharacterListView.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI

struct CharacterListView: View {
    
    @StateObject var viewModel: CharacterListViewModel
    
    private let lightMode: DarkModeEnum = .lightMode
    private let darkMode: DarkModeEnum = .darkMode
    
    var body: some View {
        NavigationStack {
            Picker("Mode", selection: $viewModel.darkModePicker) {
                Text("Light Mode").tag(lightMode.tag())
                Text("Dark Mode").tag(darkMode.tag())
            }.pickerStyle(.segmented)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
            List(viewModel.searchResults, id: \.self) { character in
                NavigationLink(character.name, value: character)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationDestination(for: CharacterModel.self, destination: CharacterDetailView.init)
                    .navigationTitle("Select a character")
                .scrollContentBackground(.hidden)
        }.overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }.onAppear(perform: {
            Task{
                try await viewModel.fetchAllCharaters()
            }
        }).searchable(text: $viewModel.searchText, prompt: "Filter characters")
            .errorAlert(error: $viewModel.error)
    }
}

#Preview {
    CharacterListView(viewModel: CharacterListViewModel(service: MockService()))
}
