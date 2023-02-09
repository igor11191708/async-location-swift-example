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
    
    @StateObject private var viewModel = LMViewModel()
    
    @StateObject private var mapViewModel = MapViewModel()
    
    @State private  var task : Task<(), Never>?
   
    // MARK: - Life circle
    
    var body: some View {
        VStack{
            let map = Map(coordinateRegion: $mapViewModel.location)
            
            toolbarTpl
            coordinatesTpl
            map
                .edgesIgnoringSafeArea(.bottom)
                .frame(height: 400)
                .onChange(of: viewModel.locations){ mapViewModel.setCurrentLocation($0) }
            
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
    private var coordinatesTpl: some View{
        List(viewModel.locations, id: \.hash) { location in
            Text("\(location.coordinate.longitude), \(location.coordinate.latitude)")
        }
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
    }
    
    // MARK: - Private
    
    var isCanceled : Bool{ task == nil }
    
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

