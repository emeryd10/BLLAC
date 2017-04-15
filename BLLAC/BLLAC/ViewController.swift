//
//  ViewController.swift
//  BLLAC
//
//  Created by Dan Emery on 3/11/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, ClientController {
    
    static var userName: String!
    private var canRequestAppt = true
    private var clientCancelledRequest = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getUserName()
        ApptHandler.Instance.observeMessagesForClient()
        ApptHandler.Instance.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserName() {
        DBProvider.Instance.clientRef.child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot:FIRDataSnapshot) in
            
            if let data = snapshot.value as? Dictionary<String, Any> {
                ViewController.userName = data[Constants.CLIENT] as! String!
            }
        })
    }

    @IBAction func logOut(_ sender: Any) {
        if logOut() {
            
            
            dismiss(animated: true, completion: nil);
            
        } else {
            // problem with logging out
            alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment, please try again later");
        }
        
    }
    func logOut() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut();
                return true;
            } catch {
                return false;
            }
        }
        return true;
    }
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    //ApptController Methods
    func canMakeAppt(delegateCalled: Bool) {
        if delegateCalled {
            //callCaddy.setTitle("Cancel Uber", for: UIControlState.normal);
            canRequestAppt = true;
        } else {
            //callCaddy.setTitle("Call Uber", for: UIControlState.normal);
            canRequestAppt = true;
        }
    }
    func apptAccepted(apptAccepted: Bool, drName: String) {
        if !clientCancelledRequest {
            if apptAccepted {
                alertTheUser(title: "Request Accepted", message: "Your Most Recent Appointment Request Has Been Accepted.")
            } else {
                ApptHandler.Instance.cancelApptRequest()
                alertTheUser(title: "Request Cancelled", message: "Your Appointment Request Has Been Cancelled")
            }
        }
        clientCancelledRequest = false;
    }

}

