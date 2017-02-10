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
    @IBOutlet weak var actView: UIView!
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    
    @IBOutlet weak var noInternetView: UIView!
    
    
    var categories: [Category]?
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actView.layer.masksToBounds = true
        actView.layer.cornerRadius = 10
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
        self.dismiss(animated: true, completion: {
            if !isInternetAvailable() {
                let vc = UIAlertController(title: "No internet", message: "Please check your connection and try again.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                vc.addAction(action)
                AppDelegate.instance().window?.rootViewController?.present(vc, animated: true, completion: nil)
                AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
            }
        })
    }
    
    //MARK: GET request calls
    func retrieveCategories() {
        self.actView.isHidden = false
        if isInternetAvailable() {
            self.noInternetView.isHidden = true
            self.ref.child("iphone6").observeSingleEvent(of: .value, with: { (snapshot) in
                var totalCount = 0
                if let cats = snapshot.value as? [String : AnyObject] {
                    self.categories = [Category]()
                    for (name,value) in cats {
                        let category = Category()
                        category.name = name
                        category.imagesCount = value.count - 1
                        totalCount += category.imagesCount
                        category.iconURL = value["icon"] as! String
                        self.categories?.append(category)
                    }
                }
                let category = Category()
                category.name = "All"
                category.imagesCount = totalCount
                category.iconURL = "https://firebasestorage.googleapis.com/v0/b/pixtic-bb2a2.appspot.com/o/category%20icons%2FHiAppHere_com_kov.theme.lumos.png?alt=media&token=7f036abb-92d4-4153-94e7-2475d35c9a97"
                let sorted = self.categories?.sorted { $0.name < $1.name }
                self.categories = sorted
                self.categories?.insert(category, at: 0)
                self.tableview.reloadData()
                self.actView.isHidden = true
            })
        }else {
            // Show no internet connection available
            self.noInternetView.isHidden = false
            self.actView.isHidden = true
        }
    }
    
    //MARK: Other methods
    @IBAction func donePressed(_ sender: Any) {
        self.dismiss(animated: true) {
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
            AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
        }
    }
    
    @IBAction func tryAgainPressed(_ sender: Any) {
        retrieveCategories()
    }
    
}
