//
//  ContentView.swift
//  async-location-swift-example
//
//  Created by Igor Shelopaev on 03.02.2023.
//

import SwiftUI
import d3_async_location
import MapKit
import async_task

typealias TaskModel = Async.SingleTask<Void, AsyncLocationErrors>

@MainActor
struct ContentView: View {
    
    @StateObject private var viewModel = LMViewModel()
    
    @StateObject private var mapViewModel = MapViewModel()
    
    @StateObject private var taskModel = TaskModel(errorMapper: errorMapper)
    
    var isActive : Bool{ taskModel.state.isActive }
    
    // MARK: - Life circle
    
    var body: some View {
        ZStack(alignment: .bottom){
            MapView(mapType: .hybrid)
                .environmentObject(mapViewModel)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0){
                toolbarTpl
                Spacer()
                dataTpl
            }
        }
        .onChange(of: viewModel.locations, perform: onLocationChange)
        .onAppear(perform: start)
        .onDisappear(perform: stop)
    }
   
    // MARK: - Private Tpl
    
    func onLocationChange(value: [CLLocation]){
        mapViewModel.setCurrentLocation(value)
    }
    
    @ViewBuilder
    var dataTpl: some View{
        ZStack(alignment: .bottom){
            VStack{
                if let error = taskModel.error{
                    ViewTpl.errorTpl(error)
                }else{
                    let center = mapViewModel.location.center
                    ViewTpl.coordinateTpl(center)
                    ViewTpl.addressTpl(mapViewModel.address)
                }
            }
        }
        .padding(.bottom, 25)
    }
    
    @ViewBuilder
    private var toolbarTpl : some View{
        HStack{
            Button("cancel"){ stop() }.disabled(!isActive)
            Button("start"){ start() }.disabled(isActive)
        }
        .toolbarItemModifier()
    }
    
    // MARK: - Private
        
    private func start(){
        taskModel.start {
            try await viewModel.start()
        }
    }
    
    private func stop(){
        taskModel.cancel()
    }
}

@Sendable
func errorMapper(_ error : Error?) -> AsyncLocationErrors?{
    if error is CancellationError{
        return .streamCanceled
    }
    
    return nil
}
