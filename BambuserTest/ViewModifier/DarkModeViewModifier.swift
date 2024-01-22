//
//  DarkModeViewModifier.swift
//  BambuserTest
//
//  Created by Lars Andersson on 2024-01-21.
//

import SwiftUI

public struct DarkModeViewModifier: ViewModifier {
    
@AppStorage("isDarkMode") var isDarkMode = true
    
    public func body(content: Content) -> some View {        
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
