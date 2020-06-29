//
//  TimetableView.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 28/06/20.
//

import SwiftUI
import Combine

struct TimetableView: View {
  let stop: String
  let displayAllStops: Bool
  
  @State private var fetchState = FetchState.fetching
  @State private var request: AnyCancellable?
  @State private var services: [BusTrainService] = []
  
  var body: some View {
    Group {
      switch fetchState {
        case .failed:
          Text("No data...")
        case .fetching:
          Text("Fetching...")
        case .success:
          List {
            ForEach(services) { departure in
              ServiceRowView(service: departure)
            }
            .listRowBackground(Color.clear)
          }
      }
    }
    .toolbar {
      Button(action: {
        print("Tapped...!")
        fetchData()
      }) {
        Label("Refresh", systemImage: "arrow.counterclockwise.circle")
          .imageScale(.large)
      }
    }
    .onAppear {
      print(stop)
      fetchData()
    }
  }
  
  func fetchData() {
    if let url = URL(string: "https://www.metlink.org.nz/api/v1/StopDepartures/" + stop) {
      print("Stop: \(stop)")
      fetchState = .fetching
      request = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: DepartureDetails.self, decoder: JSONDecoder())
        .replaceError(with: DepartureDetails())
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: parse)
    }
  }
  
  func parse(result: DepartureDetails) {
    if result.services.count == 0 {
      // fetch error!
      fetchState = .failed
    } else {
      // fetch succeeded!
      fetchState = .success
    }
    if displayAllStops {
      services = result.services
    } else {
      services = filterBy(serviceIDs: ["52", "56", "57", "58"], services: result.services)
    }
  }
  
  private func filterBy(serviceIDs: [String], services: [BusTrainService]) -> [BusTrainService] {
    let filteredServices = services.filter {
      for serviceID in serviceIDs {
        if $0.serviceID == serviceID {
          return true
        }
      }
      return false
    }
    return filteredServices
  }
}

struct TimetableView_Previews: PreviewProvider {
  static var previews: some View {
    //let store = Store()
    return TimetableView(stop: "5012", displayAllStops: false)
  }
}
