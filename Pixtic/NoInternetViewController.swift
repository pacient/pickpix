//
//  NoInternetViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 18/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class NoInternetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tryAgainPressed(_ sender: Any) {
        AppDelegate.instance().getWallpapersFromDatabase()
    }

}
