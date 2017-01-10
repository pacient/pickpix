//
//  MenuViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 10/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var tablewviewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tablewviewHeightConstraint.constant = 3*40
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        
        cell.categoryName.text = "Test"
        cell.imageCountLbl.text = "123124"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true) { 
            AppDelegate.instance().showButtons(show: true)
        }
    }
    
}
