//
//  MenuViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 10/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableview: UITableView!
    
    var categories: [Category]?
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = FIRDatabase.database().reference()

        UIApplication.shared.setStatusBarHidden(false, with: .slide)
        retrieveCategories()
    }

    //MARK: TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as! CategoryCell
        
        cell.categoryName.text = self.categories?[indexPath.row].name
        let resource = ImageResource(downloadURL: URL(string: (self.categories?[indexPath.row].iconURL!)!)!)
        cell.categoryIcon.kf.setImage(with: resource)
        cell.imageCountLbl.text = "\(self.categories![indexPath.row].imagesCount!)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("Header", owner: self, options: nil)?.first as! UIView
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        AppDelegate.instance().getWallpapers(from: self.categories![indexPath.row].name)
        UIApplication.shared.setStatusBarHidden(true, with: .slide)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: GET request calls
    func retrieveCategories() {
        
        self.ref.child(UIDevice.current.modelName).queryOrdered(byChild: "All").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let cats = snapshot.value as? [String : AnyObject] {
                self.categories = [Category]()
                for (name,value) in cats {
                    let category = Category()
                    category.name = name
                    category.imagesCount = value.count - 1
                    category.iconURL = value["icon"] as! String
                    self.categories?.append(category)
                }
            }
            let sorted = self.categories?.sorted { $0.name < $1.name }
            self.categories = sorted
            self.tableview.reloadData()
            let blurEffect = UIBlurEffect(style: .light)
            let blur = UIVisualEffectView(effect: blurEffect)
            blur.frame = self.view.frame
            self.tableview.backgroundView?.addSubview(blur)
        })
    }
    
    //MARK: Other methods
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true) {
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
            AppDelegate.instance().showButtons(show: true)
        }
    }
}
