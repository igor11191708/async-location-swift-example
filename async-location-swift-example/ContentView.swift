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
    
    @State var error : [Error] = []
    
    @State var task : Task<(), Never>?
    
    @ViewBuilder
    var coordinatesTpl: some View{
        List(viewModel.locations, id: \.hash) { location in
            Text("\(location.coordinate.longitude), \(location.coordinate.latitude)")
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                Button("cancel"){ task?.cancel() }
                Button("stop"){ viewModel.stop() }
                Button("start"){
                    task?.cancel()
                    task = Task{
                        do{
                            try await viewModel.start()
                        }catch{
                            print(error)
                        }
                        
                    } }
            }
            coordinatesTpl
        }
        .navigationTitle("Coordinates")
        .onAppear{
            let task = Task{
                do{
                    try await viewModel.start()
                }catch{
                    self.error.append(error)
                    print(error)
                }
            }
            
            self.task = task
        }
        .onDisappear{
            task?.cancel()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
