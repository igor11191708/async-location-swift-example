//
//  ToolbarItemModifier.swift
//  async-location-swift-example
//
//  Created by Igor on 09.02.2023.
//

import SwiftUI

struct ToolbarItemModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(.thickMaterial)
            .cornerRadius(25)
            .tint(.yellow)
            .font(.system(.title3))
            .fontWeight(.semibold)
    }
}
