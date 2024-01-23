//
//  BambuserTestApp.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI

@main
struct BambuserTestApp: App {
    var body: some Scene {
        WindowGroup {
            CharacterListView(viewModel: CharacterListViewModel())
                .modifier(DarkModeViewModifier())
        }
    }
}
