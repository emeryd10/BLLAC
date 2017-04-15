//
//  pharmacyViewController.swift
//  BLLAC
//
//  Created by Dan Emery on 3/23/17.
//  Copyright © 2017 Dan Emery. All rights reserved.
//

import Foundation

import UIKit

class pharmacyViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: "https://bllac.vetsfirstchoice.com/")!))
    }
    
}
