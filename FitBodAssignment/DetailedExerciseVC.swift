//
//  DetailedExerciseVC.swift
//  FitBodAssignment
//
//  Created by Victor Wei on 11/16/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit

class DetailedExerciseVC: UIViewController {

  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!
  
  var exercise: Exercise!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    
  }
  
  func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    
    let nib = UINib(nibName: "ExerciseCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "exerciseCell")
    let nib2 = UINib(nibName: "ChartCell", bundle: nil)
    tableView.register(nib2, forCellReuseIdentifier: "chartCell")
    tableView.allowsSelection = false
  }

}

extension DetailedExerciseVC: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    // First cell is to display the current one rep max
    if indexPath.row == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath) as! ExerciseCell
      
      cell.nameLabel.text = exercise.name
      // Calculate the one rep max on a background thread
      DispatchQueue.global(qos: .background).async {
        
        if let oRM = self.exercise.getMostRecentOneRepMax {
          // Set the label on the main thread
          DispatchQueue.main.async {
            if let cell = tableView.cellForRow(at: indexPath) as? ExerciseCell {
              cell.weightLabel.text = String(oRM)
            }
          }
        }
      } // end of Dispatch global queue
      return cell
      
    } else {
      
      // Display line chart showing all one rep maxes for each date
      let cell = tableView.dequeueReusableCell(withIdentifier: "chartCell") as! ChartCell
      cell.updateChart(exercise: exercise)
      return cell
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
}
