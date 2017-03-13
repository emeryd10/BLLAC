//
//  ConverterView.swift
//  Workout Suite
//
//  Created by Dan Emery on 3/11/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import Foundation
import UIKit

class ConverterView: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var value: UITextField!
    @IBOutlet weak var convertBtn: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var selector: UISegmentedControl!
    var current = 0
    let conversions: [Double] = [0.3048,3.28084,2.54,0.393701]
    let options: [String] = ["Feet To Meters", "Meters To Feet", "Inches To Centimeters","Centimeters To Inches"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        picker.dataSource = self
    }
    
    
    @IBAction func convert(_ sender: Any) {
        
        if let answer = Double(value.text!) {
            var convertConstant = conversions[current]
            var returned = answer * convertConstant
            answerLabel.text = String(returned)
        }
    }
    
    //picker view methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        current=row
        return options[row]
    }
}
