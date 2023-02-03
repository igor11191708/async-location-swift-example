//
//  ContentView.swift
//  async-location-swift-example
//
//  Created by Igor on 03.02.2023.
//

import SwiftUI
import d3_location

struct ContentView: View {
    
    @EnvironmentObject var model: LMViewModel
        
    @State var error : String?
    
    @ViewBuilder
    var coordinatesTpl: some View{
        List(model.locations, id: \.hash) { location in
            Text("\(location.coordinate.longitude), \(location.coordinate.latitude)")
        }
    }
    
    var body: some View {
        ZStack{
            if let error {
                Text(error).foregroundColor(.red)
            }else{
                coordinatesTpl
            }
        }
             .navigationTitle("Coordinates")
             .task{
                 do{
                     try await model.start()
                 }catch{
                     self.error = error.localizedDescription
                 }
             }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
