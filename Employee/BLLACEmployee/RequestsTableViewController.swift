//
//  RequestsTableViewController.swift
//  BLLACEmployee
//
//  Created by Dan Emery on 4/8/17.
//  Copyright © 2017 OneStopAthletics. All rights reserved.
//

import UIKit
import Firebase

class RequestsTableViewController: UITableViewController {
    var appts: [String] = ["YOU CURRENTLY HAVE NO APPOINTMENTS REQUESTS"]
    var requests = [Dictionary<String, Any>]()
    static var count: String = "0"
    static var clientKey: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCount()
        startObservingDB()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCount() {
        DBProvider.Instance.apptRef.observe(.value, with: { (snapshot:FIRDataSnapshot) in
            let temp = snapshot.childrenCount
            RequestsTableViewController.count = String(temp)
        })
    }
    
    func startObservingDB () {
        DBProvider.Instance.apptRef.observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
            
            var temp = [String]()
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                if var data = child.value as? Dictionary<String, Any> {
                    data.updateValue(child.key, forKey: "clientKey")
                    self.requests.append(data)
                    temp.append(data[Constants.CLIENT] as! String)
                }
            }
            self.appts = temp
            self.tableView.reloadData()
        })
        
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appts.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        cell.backgroundColor = self.view.backgroundColor
        cell.textLabel?.text = "Place \(indexPath.row + 1)"
        cell.detailTextLabel?.text = appts[indexPath.row]

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath as IndexPath)
        print(requests.count)
        if requests.count > 0 {
            ScheduleViewController.data = requests[indexPath.row]
        }
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        performSegue(withIdentifier: "ScheduleSegue", sender: cell)
    }
    
    
}
