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
        ZStack(alignment: .bottom){
            MapView(mapType: .hybrid)
                .environmentObject(mapViewModel)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                toolbarTpl
                Spacer()
                ZStack(alignment: .bottom){
                    coordinatesTpl
                        .frame(height: 302)
                }
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
    private var coordinatesTpl: some View{
        List(viewModel.locations, id: \.hash) { location in
            Text("\(location.coordinate.longitude), \(location.coordinate.latitude)")
        }
        .listRowBackground(Color.clear)
        .scrollContentBackground(.hidden)
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
        .tint(.yellow)
        .font(.system(.title3))
        .fontWeight(.semibold)
        .padding()
        .background(.thickMaterial)
        .cornerRadius(25)
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

