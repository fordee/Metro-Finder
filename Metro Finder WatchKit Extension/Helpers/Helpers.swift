//
//  Helpers.swift
//  Metro Finder WatchKit Extension
//
//  Created by John Forde on 28/06/20.
//

import Foundation

func getTimeFromDateString(from: String?) -> String {
  if let from = from {
    if from == "" { return "" }
    let indexStartOfText = from.index(from.startIndex, offsetBy: 11)
    let indexEndOfText = from.index(from.startIndex, offsetBy: 15)
    let timeString = from[indexStartOfText ... indexEndOfText]
    return String(timeString)
  } else {
    return ""
  }
}
