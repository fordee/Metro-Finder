//
//  ContentView.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 24/06/20.
//

import SwiftUI
import Combine

struct ContentView: View {
  @AppStorage("currentStop") private var currentStop = "3546"
  @AppStorage("displayAllStops") private var displayAllStops = false

  // Access the shared model object.
  let data = MetroData.shared
  
  var body: some View {
    VStack {
      Picker(selection: $currentStop, label: EmptyView()) {
        ForEach(data.stops) { stop in
          Text("\(stop.stopName)").tag("\(stop.stopNumber)")
        }
      }
      .frame(minHeight: 44, maxHeight: 44)
      NavigationLink(destination: TimetableView(stop: currentStop, displayAllStops: displayAllStops).environmentObject(data)) {
        //Label("Timetable", systemImage: "bus")//"arrow.counterclockwise.circle")
        HStack {
          Image(systemName: "bus")
            .imageScale(.large)
            .padding(.horizontal, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
          Text("Timetable")
        }
      }
      Toggle(isOn: $displayAllStops) {
        Text("Display All Stops")
      }
      .padding()
    }
    
  }
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    return ContentView()
  }
}
