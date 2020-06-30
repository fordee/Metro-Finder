//
//  MetroData.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 1/07/20.
//


import SwiftUI
import Combine
import ClockKit


enum FetchState {
  case fetching, success, failed
}

class MetroData: ObservableObject {
  static let shared = MetroData()

  // A background queue used to save and load the model data.
  private var background = DispatchQueue(label: "Background Queue", qos: .userInitiated)

  // Because this is @Published property,
  // Combine notifies any observers when a change occurs.
  @Published public var services: [BusTrainService] = []
  @Published public var fetchState: FetchState = FetchState.fetching
  @Published public var request: AnyCancellable?

  private var displayAllStops = false

  let stops: [MetStop] = [
    MetStop(stopNumber: 3546, stopName: "Newlands Road"),
    MetStop(stopNumber: 5016, stopName: "Wellington Station"),
    MetStop(stopNumber: 5014, stopName: "Lambton Quay Stop B"),
    MetStop(stopNumber: 5012, stopName: "Farmers"),
    MetStop(stopNumber: 5010, stopName: "Cable Car Lane"),
    MetStop(stopNumber: 5008, stopName: "Willis Street"),
  ]

  // A sink that is also called whenever the currentDrinks array changes.
  var updateSink: AnyCancellable!

  func fetchData(for stop: String, displayAllStops: Bool) {
    self.displayAllStops = displayAllStops
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

  // The deinitializer for the model object.
  deinit {
    // Cancel the observer.
    updateSink.cancel()
  }
}
