//
//  ChartCell.swift
//  FitBodAssignment
//
//  Created by Victor Wei on 11/16/17.
//  Copyright © 2017 vDub. All rights reserved.
//

import UIKit
import Charts

class ChartCell: UITableViewCell {

  // MARK: - Properties
  @IBOutlet weak var lineChartView: LineChartView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  func updateChart(exercise: Exercise) {
  
    // Get array of one rep maxes for each date
    let chartData = exercise.getOneRepMaxes()
    let ormArray = chartData.1
    let datesArray = chartData.0
    
    var lineChartEntry = [ChartDataEntry]()
    
    // Add CharDataEntries with x value as Date (as Double) and y value as One Rep Max
    for i in 0..<chartData.0.count {
      let value = ChartDataEntry(x: datesArray[i].millisecondsSince1970, y: Double(ormArray[i]))
      lineChartEntry.append(value)
    }
    
    // Set the LineChart to use the LineChartDataSet
    let line1 = LineChartDataSet(values: lineChartEntry, label: "One Rep Max")
    line1.colors = [NSUIColor.blue]
    
    let data = LineChartData()
    data.addDataSet(line1)
    
    lineChartView.data = data
    lineChartView.chartDescription?.text = "One Rep Maxes"
    lineChartView.xAxis.valueFormatter = self
    
    
  }
    
}

// MARK: - IAxisValueFormatter Protocol
extension ChartCell: IAxisValueFormatter {
  
  // Change the x values from Double to String
  func stringForValue(_ value: Double, axis: AxisBase?) -> String {
    
    let date = Date(milliseconds: value)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM dd yyyy"
    var formattedDate = dateFormatter.string(from: date)
    
    // Change the date string to readable format (e.g. 10 12 2017 -> Oct 12 2017)
    let dateArray = Array(formattedDate)
    let monthAsInt = String(dateArray[0]) + String(dateArray[1])
    var month = ""
    switch monthAsInt {
    case "01":
      month = "Jan"
    case "02":
      month = "Feb"
    case "03":
      month = "Mar"
    case "04":
      month = "Apr"
    case "05":
      month = "May"
    case "06":
      month = "Jun"
    case "07":
      month = "Jul"
    case "08":
      month = "Aug"
    case "09":
      month = "Sep"
    case "10":
      month = "Oct"
    case "11":
      month = "Nov"
    case "12":
      month = "Dev"
    default:
      break
    }
    formattedDate.remove(at: formattedDate.startIndex)
    formattedDate.remove(at: formattedDate.startIndex)
    
    formattedDate = month + formattedDate
    return formattedDate
  }
  
}

// MARK: - Extension for Date class
// Change Date variables to type Double, add initializer to create Date variable from type Double
extension Date {
  var millisecondsSince1970: Double {
    return (self.timeIntervalSince1970 * 1000.0)
  }
  
  
  init(milliseconds: Double) {
    self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000.0))
  }
}
