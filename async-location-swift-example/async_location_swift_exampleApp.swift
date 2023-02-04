//
//  async_location_swift_exampleApp.swift
//  async-location-swift-example
//
//  Created by Igor on 03.02.2023.
//

import SwiftUI
import d3_async_location

@main
struct ConcurrenceApp: App {
    
    @State var isOn = true
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                VStack{
                    if isOn{
                       ContentView()
                    }
                }.toolbar{
                    ToolbarItem{
                        Button(isOn ? "hide" : "show") { isOn.toggle() }
                    }
                }
            }
        }
    }
}

