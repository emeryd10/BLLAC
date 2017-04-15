//
//  ManageApptsTableViewController.swift
//  BLLAC
//
//  Created by Dan Emery on 4/8/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import UIKit
import Firebase

class ManageApptsTableViewController: UITableViewController {

    var appts: [String] = ["YOU CURRENTLY HAVE NO APPOINTMENTS SETUP"]
    var dbRef: FIRDatabaseReference = DBProvider.Instance.apptAcceptedRef.child((FIRAuth.auth()?.currentUser?.uid)!)
    var scheduled = [Dictionary<String, Any>]()

    static var count: String = "0"
    
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
        dbRef.observe(.value, with: { (snapshot:FIRDataSnapshot) in
            let temp = snapshot.childrenCount
            ManageApptsTableViewController.count = String(temp)
        })
    }
    
    func startObservingDB () {
        DBProvider.Instance.apptAcceptedRef.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
            
            var temp = [String]()
            
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                print("MARK")
                if var data = child.value as? Dictionary<String, Any> {
                    
                    data.updateValue(snapshot.key, forKey: "clientKey")
                    self.scheduled.append(data)
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
        //let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell")
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.backgroundColor = self.view.backgroundColor
        if scheduled.count > 0 {
            let req = scheduled[indexPath.row]
            cell.textLabel?.text = (req[Constants.DATE] as! String) + " At " + (req[Constants.START] as! String)
            cell.detailTextLabel?.text = appts[indexPath.row]
        }
        
        
        return cell
    }


}
