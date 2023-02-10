//
//  ContentView.swift
//  async-location-swift-example
//
//  Created by Igor on 03.02.2023.
//

import SwiftUI
import d3_async_location
import MapKit

struct ContentView: View {
    
    @StateObject private var viewModel = LMViewModel(strategy: .keepLast)
    
    @StateObject private var mapViewModel = MapViewModel()
    
    @State private  var task : Task<(), Never>?
    
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
                    coordinateTpl
                }
                .padding(.bottom, 25)
            }            
        }
        .onChange(of: viewModel.locations){ value in
            mapViewModel.setCurrentLocation(value)
        }
        .navigationTitle("Async/await Location")
        .onAppear{
            startTask()
        }
        .onDisappear{
            cancelTask()
        }
    }
   
    // MARK: - Private Tpl
    
    @ViewBuilder
    private var coordinateTpl: some View{
        let center = mapViewModel.location.center
        Text("\(center.longitude), \(center.latitude)")
            .fontWeight(.semibold)
            .modifier(ToolbarItemModifier())
    }
    
    @ViewBuilder
    private var toolbarTpl : some View{
        HStack{
            Group{
                Button("cancel"){ cancelTask() }
                Button("stop"){ viewModel.stop(); cancelTask() }
            }.disabled(isCanceled)
            Button("start"){ startTask() }.disabled(!isCanceled)
        }
        .modifier(ToolbarItemModifier())
    }
    
    // MARK: - Private
    
    private var isCanceled : Bool{ task == nil }
    
    private func startTask(){
        task = Task{
            do{
                try await viewModel.start()
            }catch{
                cancelTask()
                print(error)
            }
        }
    }
    
    private func cancelTask(){
        task?.cancel()
        task = nil
    }
}
