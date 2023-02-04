//
//  ContentView.swift
//  async-location-swift-example
//
//  Created by Igor on 03.02.2023.
//

import SwiftUI
import d3_async_location

struct ContentView: View {
    
    @StateObject var viewModel = LMViewModel()
    
    @State var task : Task<(), Never>?
    
    @ViewBuilder
    var coordinatesTpl: some View{
        List(viewModel.locations, id: \.hash) { location in
            Text("\(location.coordinate.longitude), \(location.coordinate.latitude)")
        }
    }
    
    var isCanceled : Bool{ task == nil }
    
    private func startTask(){
        task = Task{
            do{
                try await viewModel.start()
            }catch{
                print(error)
            }
        }
    }
    
    private func cancelTask(){
        task?.cancel()
        task = nil
    }
    
    @ViewBuilder
    var toolbarTpl : some View{
        HStack{
            Button("cancel"){ cancelTask() }.disabled(isCanceled)
            Button("stop"){ viewModel.stop(); cancelTask() }
            Button("start"){ startTask() }
        }
    }
    
    var body: some View {
        VStack{
            toolbarTpl
            coordinatesTpl
        }
        .navigationTitle("Coordinates")
        .onAppear{
            startTask()
        }
        .onDisappear{
            cancelTask()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
