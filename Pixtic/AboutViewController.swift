//
//  AboutViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 19/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    
    @IBOutlet weak var versionLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        versionLbl.text = "Version \(Bundle.main.infoDictionary!["CFBundleShortVersionString"]!)"
    }

    @IBAction func aboutPressed(_ sender: Any) {
        
    }
    
    @IBAction func suggestionPressed(_ sender: Any) {
        
    }
    
    @IBAction func removeAdsPressed(_ sender: Any) {
        
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true) { 
            AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
        }
    }
    
}
