//
//  WorkoutHistory.swift
//  FitBodAssignment
//
//  Created by Victor Wei on 11/15/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import Foundation

class WorkoutHistory {
  
  static let shared = WorkoutHistory()
  private init(){}
  
  // Array of all exercises done
  var exercises: [Exercise] = []
  
}
