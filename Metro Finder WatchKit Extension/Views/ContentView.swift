//
//  ContentView.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 24/06/20.
//

import SwiftUI
import Combine

enum FetchState {
   case fetching, success, failed
}

struct ContentView: View {
  @State var currentStop: String = "3546"
  
  let stops: [MetStop] = [
    MetStop(stopNumber: 3546, stopName: "Newlands Road"),
    MetStop(stopNumber: 5016, stopName: "Wellington Station"),
    MetStop(stopNumber: 5014, stopName: "Lambton Quay Stop B"),
    MetStop(stopNumber: 5012, stopName: "Farmers"),
    MetStop(stopNumber: 5010, stopName: "Cable Car Lane"),
    MetStop(stopNumber: 5008, stopName: "Willis Street"),
  ]
  
  
  
  var body: some View {
    
    VStack {
      Picker(selection: $currentStop, label: EmptyView()) {
        ForEach(stops) { stop in
          Text("\(stop.stopName)").tag("\(stop.stopNumber)")
        }
      }
      .frame(minHeight: 44, maxHeight: 44)
      NavigationLink(destination: TimetableView(stop: currentStop)) {
        Label("Refresh", systemImage: "arrow.counterclockwise.circle")
          .imageScale(.large)
      }
    }
    
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    return ContentView()
  }
}
