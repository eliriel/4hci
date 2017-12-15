//
//  TimesPieChart.swift
//  MedReminder
//
//  Created by Borislav Hristov on 30.11.17.
//  Copyright © 2017 Borislav Hristov. All rights reserved.
//

import Foundation
import UIKit
import Charts


class TimesPieChart: OpenReminderController, ChartViewDelegate{
    @IBOutlet weak var pieVIew: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if var takeTimes = self.reminder?.getTakeTimes(){
            
            takeTimes = takeTimes.sorted {
                if let first = $0.shouldHaveTaken as? Date, let second = $1.shouldHaveTaken as? Date{
                    return first > second
                }
                return false
            }
         

            var success = 0.0
            var fail = 0.0

            for takeTime in takeTimes{
            
            if abs(Int32((takeTime.shouldHaveTaken?.timeIntervalSince(takeTime.takenTime as! Date))!)) > 600 {
                fail+=1
            } else {
                success+=1
            }
            }
            
            self.updateChartData(success: success , fail: fail)
        }
    }
    
    func updateChartData(success: Double , fail: Double)  {
        
        // 2. generate chart data entries
        let track = ["On time", "Missed"]
        let money = [success, fail]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieVIew.data = data
        pieVIew.noDataText = "No data available"
        // user interaction
        pieVIew.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = ""
        pieVIew.chartDescription = d
        pieVIew.centerText = ""
        pieVIew.holeRadiusPercent = 0.2
        pieVIew.transparentCircleColor = UIColor.clear
    }
    /*
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [10.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        setChart(dataPoints: months, values: unitsSold)
        
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry1 = ChartDataEntry(x: Double(i), y: values[i], data: dataPoints[i] as AnyObject)
            
            dataEntries.append(dataEntry1)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieVIew.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
    */
    
}

