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
                }.toolbar{  ToolbarItem{ button } }
            }
            .preferredColorScheme(.dark)
        }
    }
    
    @ViewBuilder
    private var button : some View {
       
            Button(action: { isOn.toggle() }, label: {
                Text(isOn ? "hide" : "show")
                    .padding(5)
                    .padding(.horizontal, 10)
                    .background(.thickMaterial)
                    .cornerRadius(25)
                    .tint(.yellow)
                    .font(.system(.title3))
                    .fontWeight(.semibold)
            })
        
    }
    
}

