//
//  DepartureCellView.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 27/06/20.
//

import SwiftUI
import ComposableArchitecture

struct DepartureCellView: View {
  let service: String
  let time: String
  let onTime: String

  
  var body: some View {
    VStack {
      HStack {
        Text("[\(service)] ")
          .font(.headline)
          .fontWeight(.bold)
        Text(getTimeFromDateString(from: time))
          .font(.headline)
          .fontWeight(.bold)
        Spacer()
      }
      HStack {
        Text(onTime)
          .font(.subheadline)
          .foregroundColor(.gray)
        Spacer()
      }
    }
    .frame(maxWidth: .infinity)
    //.padding(.all, 10)
    

//    .background(Color.purple)
//    .cornerRadius(20.0)
  }
}

struct DepartureCellView_Previews: PreviewProvider {
  static var previews: some View {
    DepartureCellView(service: "52", time: "14:53", onTime: "On Time")
  }
}
