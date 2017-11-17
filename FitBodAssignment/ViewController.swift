//
//  ViewController.swift
//  FitBodAssignment
//
//  Created by Victor Wei on 11/15/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit
import Charts


class ViewController: UIViewController {
  
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    getData()
  }
  
  // Setup tableView
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    let nib = UINib(nibName: "ExerciseCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "exerciseCell")
  }
  
  // Load data from workoutData.txt file.
  // Parse the data and add it to our datasource.
  // Reload the tableView when finished
  func getData() {
    if let path = Bundle.main.path(forResource: "workoutData", ofType: "txt") {
      do {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        let myStrings = data.components(separatedBy: .newlines)
        parseData(data: myStrings)
        self.tableView.reloadData()
        
      } catch {
        print(error)
      }
    }
  }
  
  // Function to parse data and add info for our datasource6
  func parseData(data: [String]) {
    
    // variables used to check if the next entry is the same as the previous entry's date and exercise
    var currentDate = ""
    var currentExercise = ""
    
    // array to hold all sets from a current day
    var dailySets: [DailySet] = []
    
    for line in data {
      if line == "" {
        continue
      }
      
      var newData = line.split(separator: ",")
      
      let date = String(newData[0])
      let exercise = String(newData[1])
      
      // Check to see if the date and exercise has changed from the previous entry
      if (currentDate != date || currentExercise != exercise) &&
        currentDate != "" {
        
        //convert the date (String) to a (Date) variable
        if let theDate = currentDate.convertToDate() {
          
          let wod = Wod(date: theDate, sets: dailySets)
      
          // Check if the WorkoutHistory already has an entry for the specific exercise
          if let index = WorkoutHistory.shared.exercises.index(where: { (exercise) -> Bool in
            return exercise.name == currentExercise
          }) {
            
            // Check if that exercise already has an entry for that specific date.
            if let index1 = WorkoutHistory.shared.exercises[index].wods.index(where: { (wod) -> Bool in
              return wod.date == currentDate.convertToDate()
            }) {
              // There is already a date associated with this exercise.  append only the daily set to that wod
              for set in dailySets {
                WorkoutHistory.shared.exercises[index].wods[index1].sets.append(set)
              }
            } else {
              // There is no date associated with the exercise.  Add the wod to the exercise
              WorkoutHistory.shared.exercises[index].appendWod(wod: wod)
            }
            
          } else {
            //This exercise has not been recorded in workout history.  Add the exercise to the workout history.
            let exercise = Exercise(name: currentExercise, workouts: wod)
            WorkoutHistory.shared.exercises.append(exercise)
          }
        } else {
          print("Error: couldn't convert date(String) to date variable")
        }
        
        dailySets.removeAll()
      }
      
      // Add the sets to an array of daily sets while the date and exercise are the same.
      currentDate = date
      currentExercise = exercise
      
      let set = DailySet(reps: Int(newData[3])!, weight: Int(newData[4])!)
      dailySets.append(set)
    }
  }

  
  
}



// MARK: - UITableView Delegate/Datasource Methods
extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return WorkoutHistory.shared.exercises.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let exercise = WorkoutHistory.shared.exercises[indexPath.row]
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCell
    cell.nameLabel.text = exercise.name
    
    // Calculate the one rep max on a background thread
    DispatchQueue.global(qos: .background).async {
      if let oRM = exercise.getMostRecentOneRepMax {
        // Set the label on the main thread
        DispatchQueue.main.async {
          if let cell = tableView.cellForRow(at: indexPath) as? ExerciseCell {
            cell.weightLabel.text = String(oRM)
          }
        }
      }
    } // end of Dispatch global queue
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let detailedVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detailedVC") as! DetailedExerciseVC
    detailedVC.exercise = WorkoutHistory.shared.exercises[indexPath.row]
    self.navigationController?.pushViewController(detailedVC, animated: true)
    
  }
}

