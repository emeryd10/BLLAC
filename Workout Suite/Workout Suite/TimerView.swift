//
//  File.swift
//  Workout Suite
//
//  Created by Dan Emery on 3/10/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import Foundation
import UIKit

class TimerView : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var laps:[String] = []
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var lapsTableView: UITableView!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!

    
    
    var timer = Timer()
    
    var minutes: Int = 0
    var seconds: Int = 0
    var fraction: Int = 0
    var started: Bool = true
    var addLap: Bool = false
    var addResult: Bool = false
    

    
    @IBAction func startStop(_ sender: Any) {

        

        if (started == true) {
            timer = Timer.scheduledTimer(timeInterval: 0.01, target:self, selector: #selector(updateStopwatch), userInfo: nil, repeats:true)
            startStopButton.setTitle("Stop", for: .normal)
            resetButton.setTitle("Lap", for: .normal)
            

            
            addLap = true
            started = false
            
            
        } else {
            timer.invalidate()
            started = true
            startStopButton.setTitle("Start", for: .normal)
            resetButton.setTitle("Reset", for: .normal)
            addLap = false
        }
        
    }
    @IBAction func lap(_ sender: Any) {
        if addLap == true {
            laps.append(timeLabel.text!)
            //laps.insert(timeLabel.text! , at: )
            lapsTableView.reloadData()
            
            
            
        } else {
            addLap = false
            fraction = 0
            seconds = 0
            minutes = 0
            timeLabel.text = "00:00.00"
            laps.removeAll()
            lapsTableView.reloadData()
            
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        timeLabel.text = "00:00.00"
        
        
        
    }
    @objc func updateStopwatch() {
        fraction += 1
        if fraction == 100 {
            seconds += 1
            fraction = 0
        }
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        let fractionString = fraction > 9 ? "\(fraction)" : "\(fraction)"
        let secondString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minuteString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        timeLabel.text = minuteString + ":" + secondString + "." + fractionString
    }

    //Table View Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.backgroundColor = self.view.backgroundColor
        cell.textLabel?.text = "Place \(indexPath.row + 1)"
        cell.detailTextLabel?.text = laps[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }

}

