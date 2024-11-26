//
//  ContentView.swift
//  async-location-swift-example
//
//  Created by Igor Shelopaev on 03.02.2023.
//

import SwiftUI
import d3_async_location
import MapKit

@MainActor
struct ContentView: View {
    
    @StateObject private var viewModel = LMViewModel()
    
    @StateObject private var mapViewModel = MapViewModel()
    
    @StateObject private var taskModel = TaskViewModel()
    
    @State private var address : String = ""
    
    @State private var isActive = false
    
    // MARK: - Life circle
    
    var body: some View {
        ZStack(alignment: .bottom){
            MapView(mapType: .hybrid)
                .environmentObject(mapViewModel)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                toolbarTpl
                Spacer()
                ZStack(alignment: .bottom){
                    VStack{
                        coordinateTpl
                        addressTpl
                    }
                }
                .padding(.bottom, 25)
            }
        }
        .onChange(of: viewModel.locations){ value in
            mapViewModel.setCurrentLocation(value)
        }
        .onAppear(perform: start)
        .onDisappear(perform: stop)
    }
   
    // MARK: - Private Tpl
    
    @ViewBuilder
    private var coordinateTpl: some View{
            HStack {
                let center = mapViewModel.location.center
                Text("Longitude: \(center.longitude, specifier: "%.6f")")
                Spacer()
                Text("Latitude: \(center.latitude, specifier: "%.6f")")
            }.toolbarItemModifier()
            .padding(.horizontal)
    }
    
    @ViewBuilder
    private var addressTpl: some View{
            Text(mapViewModel.address)
                .toolbarItemModifier()
    }
    
    @ViewBuilder
    private var toolbarTpl : some View{
        HStack{
            Button("stop"){ stop() }.disabled(!isActive)
            Button("start"){ start() }.disabled(isActive)
        }
        .toolbarItemModifier()
    }
    
    // MARK: - Private
        
    private func start(){
        taskModel.start {
            try await viewModel.start()
        }
        isActive = true
    }
    
    private func stop(){
        isActive = false
        taskModel.stop()
    }
}
