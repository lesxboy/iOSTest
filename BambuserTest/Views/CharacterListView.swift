//
//  CharacterListView.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI

struct CharacterListView: View {
    
    @StateObject var viewModel: CharacterListViewModel
    
    var body: some View {
        NavigationStack {
            Picker("Mode", selection: $viewModel.darkModePicker) {
                Text("Light Mode").tag(0)
                Text("Dark Mode").tag(1)
            }.pickerStyle(.segmented)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
            List(viewModel.searchResults, id: \.self) { character in
                NavigationLink(character.name, value: character)
            }.onAppear(perform: {
                Task{
                    try await viewModel.fetchAllCharaters()
                }
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
                .navigationDestination(for: CharacterModel.self, destination: CharacterDetailView.init)
                    .navigationTitle("Select a character")
                .scrollContentBackground(.hidden)
        }.overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }.searchable(text: $viewModel.searchText, prompt: "Filter characters")
            .errorAlert(error: $viewModel.error)
    }
}

#Preview {
    CharacterListView(viewModel: CharacterListViewModel(service: MockService()))
}
