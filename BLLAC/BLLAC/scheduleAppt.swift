//
//  scheduleAppt.swift
//  BLLAC
//
//  Created by Dan Emery on 3/11/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import MapKit
import Firebase
import CoreLocation


class scheduleViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ClientController, CLLocationManagerDelegate, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var perfHorse: UISegmentedControl!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var urgencySlider: UISlider!
    @IBOutlet weak var disciplineTF: UITextField!
    @IBOutlet weak var urgencyLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var numDocsTB: UITextField!
    @IBOutlet weak var durationTF: UITextField!
    @IBOutlet weak var locationSeg: UISegmentedControl!
    @IBOutlet weak var requireDr: UISegmentedControl!
    var current = 0
    
    let phoneNumber = "269 967-8259"
    
    private var canRequestAppt = true
    private var clientCancelledRequest = false
    var pickerDataSource: [String] = ["Select Procedure", "Accupuncture","Chiropractic","Dentistry","Shoes", "Joint Injection"]
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    
    private var appStartedForTheFirstTime = true
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController!, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    

    override func viewDidLoad() {

        super.viewDidLoad()
        initializeLocationManager()
        
        //ApptHandler.Instance.observeMessagesForClient()
        //ApptHandler.Instance.delegate = self
        
        
        
        picker.delegate = self
        picker.dataSource = self

        timeLabel.text = "30 Minutes"
    }
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            //myMap.setRegion(region, animated: true);
            
            //myMap.removeAnnotations(myMap.annotations);
            
            
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = userLocation!;
            annotation.title = "My Location";
            //myMap.addAnnotation(annotation);
        }
        
    }
    @IBAction func changed(_ sender: Any) {
        if perfHorse.titleForSegment(at: perfHorse.selectedSegmentIndex) == "Yes" {
            disciplineTF.isEnabled = true
        } else {
            disciplineTF.text = ""
            disciplineTF.isEnabled = false
        }
    }
    @IBAction func timeChanged(_ sender: Any) {
        var time = Int((timeSlider.value + 2.5) / 5) * 5
        timeLabel.text = String(time) + " Minutes"
        
    }
    @IBAction func urgencyChanged(_ sender: Any) {
        var urgency = Int(urgencySlider.value)
        urgencyLabel.text = String(urgency)
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    @IBAction func submit(_ sender: Any) {
//        let mailComposeViewController = configuredMailComposeViewController()
//        if MFMailComposeViewController.canSendMail() {
//            self.present(mailComposeViewController, animated: true, completion: nil)
//        } else {
//            self.showSendMailErrorAlert()
//        }
        let duration = durationTF.text
        let docs = numDocsTB.text
        let disc = disciplineTF.text
        let perf = perfHorse.titleForSegment(at: perfHorse.selectedSegmentIndex)
        let drEmery = requireDr.titleForSegment(at: requireDr.selectedSegmentIndex)
        
        if userLocation != nil {
            if canRequestAppt {

                ApptHandler.Instance.requestAppt(clientName: ViewController.userName, latitude: (userLocation?.latitude)!, longitude: (userLocation?.longitude)!, procedure: pickerDataSource[current], timeEst: timeLabel.text!, duration: duration!, urgency: Int(urgencyLabel.text!)!, numDocs: docs!, perfHorse: perf!, discipline: disc!, reqDrEmery: drEmery!)
//                if (MFMessageComposeViewController.canSendText()) {
//                    let controller = MFMessageComposeViewController()
//                    controller.body = "Message Body"
//                    controller.recipients = [phoneNumber]
//                    controller.messageComposeDelegate = self
//                    controller.
//                    self.present(controller, animated: true, completion: nil)
//                }
                
                
            } else {
                print("mark")
                clientCancelledRequest = true
                ApptHandler.Instance.cancelApptRequest()
                //timer.invalidate();
            }
        } else {
            let setAlert = UIAlertController(title: "Please Choose Location", message: "Search for the golf course you wish to play on. Once selected, a marker will be place on the golf course you chose. If this is the correct location, select the 'Set Location' button.", preferredStyle: .alert)
            
            
            setAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action:UIAlertAction) in
            }))
            
            self.present(setAlert, animated:true, completion: nil)
            
        }
    }
//    func configuredMailComposeViewController() -> MFMailComposeViewController {
//        let mailComposerVC = MFMailComposeViewController()
//        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
//        let duration = durationTF.text
//        let docs = numDocsTB.text
//        let disc = disciplineTF.text
//        let perf = perfHorse.titleForSegment(at: perfHorse.selectedSegmentIndex)
//        let drEmery = requireDr.titleForSegment(at: requireDr.selectedSegmentIndex)
//        let location = locationSeg.titleForSegment(at: locationSeg.selectedSegmentIndex)
//        let messageStr = "Client Name: Dan Emery   Appointment Reason: \(pickerDataSource[current]) Duration of Appointment: \(timeLabel.text!) Location: \(location!) Duration of Problem: \(duration!) Number of Doctors: \(docs!) Performance Horses?: \(perf!) Discipline: \(disc!) Dr. Emery Required?: \(drEmery!)"
//        mailComposerVC.setToRecipients(["emeryd10@gmail.com"])
//        mailComposerVC.setSubject("Sending you an in-app e-mail...")
//        mailComposerVC.setMessageBody(messageStr, isHTML: false)
//        
//        return mailComposerVC
//    }
    
//    func showSendMailErrorAlert() {
//        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        sendMailErrorAlert.show()
//    }
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    //MARK: picker view delegate and datasource methods
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        current = row
        return pickerDataSource[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
                alertTheUser(title: "Request Accepted", message: "Your Appointment Request Has Been Accepted.")
            } else {
                ApptHandler.Instance.cancelApptRequest()
                alertTheUser(title: "Request Cancelled", message: "Your Appointment Request Has Been Cancelled")
            }
        }
        clientCancelledRequest = false;
    }
    
    
    
}
