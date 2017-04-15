//
//  CaddyHandler.swift
//  BLLACEmployee
//
//  Created by Dan Emery on 4/8/17.
//  Copyright © 2017 OneStopAthletics. All rights reserved.
//
import Foundation
import FirebaseDatabase
import UserNotifications
import UserNotificationsUI

protocol ClientController: class {
    func acceptRequest(lat: Double, long: Double)
    func requestCanceled()
}
class ApptHandler {
    private static let _instance = ApptHandler()
    
    weak var delegate: ClientController?
    var client = ""
    var doctor = ""
    var client_id = ""
    
    static var Instance: ApptHandler {
        return _instance
    }
    
    func observeMessagesForClient() {
        //Appointment Requested By Client
        DBProvider.Instance.apptRef.observe(FIRDataEventType.childAdded) { (snapshot:FIRDataSnapshot) in

            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        self.delegate?.acceptRequest(lat: latitude, long: longitude)
                    }
                }
                if let name = data[Constants.CLIENT] as? String {
                    self.client = name
                }
            }
        }
        //Client Cancelled Appointment Request
        DBProvider.Instance.apptRef.observe(FIRDataEventType.childAdded) { (snapshot:FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.CLIENT] as? String {
                    self.client = ""
                    self.delegate?.requestCanceled()
                }
            }
        }
        //Appointment Has Been Scheduled
        DBProvider.Instance.apptAcceptedRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.CLIENT] as? String {
                    if self.doctor == "" {
                        self.client_id = snapshot.key
                    }
                }
            }
        }
    }
    func scheduleAppt(clientID: String, data: Dictionary<String, Any>, index: String) {
        DBProvider.Instance.apptAcceptedRef.child(clientID).child(index).setValue(data)
        DBProvider.Instance.apptRef.child(clientID).removeValue()
    }
}
