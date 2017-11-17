//
//  Workout.swift
//  FitBodAssignment
//
//  Created by Victor Wei on 11/15/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation


struct Wod {
  var date: Date
  var sets: [DailySet]
  
  // get the one rep max for the day
  // iterate through each set and calculate the one rep max.  One rep max for the day is the max orm from all sets
  var oneRepMax: Int {
    var orm = 0
    for set in sets {
      let oneRepMax: Int = (set.weight *  36) / (37 - set.reps)
      orm = max(orm, oneRepMax)
    }
    return orm
  }
}


struct DailySet {
  var reps: Int
  var weight: Int
}


class Exercise {
  
  var name: String
  var wods: [Wod] = []
  
  var getMostRecentOneRepMax: Int? {
    // Make sure workouts are sorted with the most recent workout in the front
    let orderedByDate = wods.sorted(by: { $0.date > $1.date})
    if let lastSet = orderedByDate.first?.sets.last {
      let oneRepMax: Int = (lastSet.weight *  36) / (37 - lastSet.reps)
      return oneRepMax
    }
    return nil
  }
  
  
  init(name: String, workouts: Wod) {
    self.name = name
    self.wods.append(workouts)
  }
  
  func appendWod(wod: Wod) {
    self.wods.append(wod)
  }
  
  // Function to get the one rep maxes for each date
  // ordered by date.  Latest date is at the end of the array
  func getOneRepMaxes()-> ([Date], [Int]) {
    let orderedByDate = wods.sorted(by: {$0.date < $1.date})
    
    var date: [Date] = []
    var orm: [Int] = []
    
    for wod in orderedByDate {
      date.append(wod.date)
      orm.append(wod.oneRepMax)
    }
    return (date, orm)
    
  }
  
  
}

// Extension used to convert a date in string format to Date variable
extension String {
  
  func convertToDate() -> Date? {
    var correctedDate = ""
    correctedDate = self.replacingOccurrences(of: "Jan", with: "01")
    correctedDate = self.replacingOccurrences(of: "Feb", with: "02")
    correctedDate = self.replacingOccurrences(of: "Mar", with: "03")
    correctedDate = self.replacingOccurrences(of: "Apr", with: "04")
    correctedDate = self.replacingOccurrences(of: "May", with: "05")
    correctedDate = self.replacingOccurrences(of: "Jun", with: "06")
    correctedDate = self.replacingOccurrences(of: "Jul", with: "07")
    correctedDate = self.replacingOccurrences(of: "Aug", with: "08")
    correctedDate = self.replacingOccurrences(of: "Sep", with: "09")
    correctedDate = self.replacingOccurrences(of: "Oct", with: "10")
    correctedDate = self.replacingOccurrences(of: "Nov", with: "11")
    correctedDate = self.replacingOccurrences(of: "Dec", with: "12")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM dd yyyy"
    
    return dateFormatter.date(from: correctedDate)
  }
  
  
  
  
}



class Workout {
  
  var date: Date
  var name: String
  var reps: Int
  var weight: Int
  
  init?(data: String) {
    
    if data == "" {
      return nil
    }
    
    var newData = data.split(separator: ",")
    
    guard let date = String(newData[0]).convertToDate() else {
      return nil
    }
    
    self.date = date
    self.name = String(newData[1])
    self.reps = Int(newData[3])!
    self.weight = Int(newData[4])!
  }
}
