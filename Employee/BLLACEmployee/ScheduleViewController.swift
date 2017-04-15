//
//  ScheduleViewController.swift
//  BLLACEmployee
//
//  Created by Dan Emery on 4/8/17.
//  Copyright © 2017 OneStopAthletics. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class ScheduleViewController: UIViewController {

    static var data = Dictionary<String, Any>()
    
    @IBOutlet weak var clientLabel: UILabel!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var perfLabel: UILabel!
    @IBOutlet weak var discLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        clientLabel.text = "Client: " + (ScheduleViewController.data[Constants.CLIENT] as! String?)!
        perfLabel.text = "Performance Horse? " + (ScheduleViewController.data[Constants.PERFHORSE] as! String?)!
        discLabel.text = "Discipline: " + (ScheduleViewController.data[Constants.DISCIPLINE] as! String?)!
        timeLabel.text = "Estimated Time: " + (ScheduleViewController.data[Constants.TIMEREQUIRED] as! String?)!
        endTimeLabel.text = "Need to finish this"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        var minText = ScheduleViewController.data[Constants.TIMEREQUIRED] as! String?
        let minInt = Int((minText?.components(separatedBy: " ")[0])!)
        startTimeLabel.text = timeFormatter.string(from: startTime.date)
        let endTime = startTime.date + TimeInterval(minInt!)
        endTimeLabel.text = timeFormatter.string(from: endTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
        
        
        
        
    }

    @IBAction func setTime(_ sender: Any) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        var minText = ScheduleViewController.data[Constants.TIMEREQUIRED] as! String?
        let minInt = Int((minText?.components(separatedBy: " ")[0])!)
        print(minInt)
        startTimeLabel.text = timeFormatter.string(from: startTime.date)
        let endTime = startTime.date + TimeInterval(minInt!)
        endTimeLabel.text = timeFormatter.string(from: endTime)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scheduleAppointment(_ sender: Any) {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        AppointmentTableViewController.getCount()
        print(AppointmentTableViewController.count)
        ScheduleViewController.data.updateValue(timeFormatter.string(from: startTime.date), forKey: Constants.START)
        ScheduleViewController.data.updateValue(dateFormatter.string(from: datePicker.date), forKey: Constants.DATE)
        ApptHandler.Instance.scheduleAppt(clientID: ScheduleViewController.data["clientKey"] as! String, data: ScheduleViewController.data, index: AppointmentTableViewController.count)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
