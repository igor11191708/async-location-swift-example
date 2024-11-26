//
//  ToolbarItemModifier.swift
//  async-location-swift-example
//
//  Created by Igor on 09.02.2023.
//

import SwiftUI

/// A view modifier that styles toolbar items with consistent padding, background, corner radius, tint, and font.
struct ToolbarItemModifier: ViewModifier {
    
    /// Modifies the appearance of the content with predefined styling.
    ///
    /// - Parameter content: The content to be styled.
    /// - Returns: A styled view with the specified padding, background, corner radius, tint, and font.
    func body(content: Content) -> some View {
        content
            .font(.system(size: 29, weight: .medium, design: .rounded))
            .padding()
            .background(.thinMaterial)
            .cornerRadius(15)
            .shadow(radius: 2)
    }
}

extension View {
    /// A convenience method to apply the `ToolbarItemModifier`.
    func toolbarItemModifier() -> some View {
        self.modifier(ToolbarItemModifier())
    }
}
