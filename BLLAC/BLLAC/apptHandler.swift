//
//  apptHandler.swift
//  BLLAC
//
//  Created by Dan Emery on 4/8/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol ClientController: class {
    func canMakeAppt(delegateCalled: Bool)
    func apptAccepted(apptAccepted: Bool, drName: String)
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
        //Appointment Requested 
        DBProvider.Instance.dbRef.observe(FIRDataEventType.childAdded) { (snapshot:FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.CLIENT] as? String {
                    if name == self.client {
                        self.client_id = snapshot.key
                        self.delegate?.canMakeAppt(delegateCalled: true)
                    }
                }
            }
        }
        //Client Cancelled Appointment Request
        DBProvider.Instance.dbRef.observe(FIRDataEventType.childAdded) { (snapshot:FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.CLIENT] as? String {
                    self.delegate?.canMakeAppt(delegateCalled: false)
                }
            }
        }
        //Appointment Has Been Scheduled
        DBProvider.Instance.apptAcceptedRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.CLIENT] as? String {
                    if self.doctor == "" {
                        self.doctor = name
                        self.delegate?.apptAccepted(apptAccepted: true, drName: self.doctor)
                    }
                }
            }
        }
    }
    func requestAppt(clientName: String, latitude: Double, longitude: Double, procedure: String, timeEst: String, duration: String, urgency: Int, numDocs: String, perfHorse: String, discipline: String, reqDrEmery: String) {
        let data: Dictionary<String, Any> = [Constants.CLIENT: clientName, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude, Constants.TIMEREQUIRED: timeEst, Constants.PROCEDURE: procedure, Constants.DURATION: duration, Constants.URGENCY: urgency, Constants.NUMDOCS: numDocs, Constants.PERFHORSE: perfHorse, Constants.DISCIPLINE: discipline, Constants.DREMERY: reqDrEmery]
        DBProvider.Instance.apptRef.child((FIRAuth.auth()?.currentUser?.uid)!).setValue(data)
    }
    func cancelApptRequest() {
        DBProvider.Instance.dbRef.child(client_id).removeValue()
    }
    func createClient(name: String) {
        let data: Dictionary<String, Any> = [Constants.CLIENT: name]
        DBProvider.Instance.clientRef.child((FIRAuth.auth()?.currentUser?.uid)!).setValue(data)
    }

}
