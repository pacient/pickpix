//
//  AppDelegate.swift
//  Pixtic
//
//  Created by Vasil Nunev on 05/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var images: [Photo]!
    var currentImage: UIImage!
    let view = UIView()
    
    
    class func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        getWallpapersFromDatabase()
        
        return true
    }
    
    func getWallpapersFromDatabase() {
        let ref = FIRDatabase.database().reference()
        
        ref.child("Wallpaper").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let wallpapers = snapshot.value as? [String : AnyObject] {
                self.images = [Photo]()
                for (id,url) in wallpapers {
                    let photo = Photo()
                    photo.photoID = id
                    photo.imageURL = url as! String
                    self.images.append(photo)
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getVC"), object: nil)
            }
        })
        ref.removeAllObservers()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func addButtonView() {
        if let window = window {
            view.backgroundColor = UIColor.clear
            view.frame = CGRect(x: 0, y: window.frame.height - 70, width: window.frame.width, height: 70)
            
            //save button
            let saveButton = UIButton()
            saveButton.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 50, height: 50)
            saveButton.addTarget(self, action: #selector(self.savePressed), for: .touchUpInside)
            saveButton.setImage(#imageLiteral(resourceName: "saveSVG"), for: .normal)
            saveButton.translatesAutoresizingMaskIntoConstraints = false
            
            let centerX = NSLayoutConstraint(item: saveButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
            let centerY = NSLayoutConstraint(item: saveButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            let height = NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            let width = NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            
            // menu button
            let menuButton = UIButton()
            menuButton.addTarget(self, action: #selector(toogleMenu), for: .touchUpInside)
            menuButton.setImage(#imageLiteral(resourceName: "menuICON"), for: .normal)
            menuButton.translatesAutoresizingMaskIntoConstraints = false
            
            let centerYmenu = NSLayoutConstraint(item: menuButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            let leading = NSLayoutConstraint(item: menuButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 8)
            let menuHeight = NSLayoutConstraint(item: menuButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            let menuWidth = NSLayoutConstraint(item: menuButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            
            //share button
            let shareButton = UIButton()
            shareButton.addTarget(self, action: #selector(shareWallpaper), for: .touchUpInside)
            shareButton.setImage(#imageLiteral(resourceName: "sharePNG"), for: .normal)
            shareButton.translatesAutoresizingMaskIntoConstraints = false
            
            let centerYshare = NSLayoutConstraint(item: shareButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            let trailing = NSLayoutConstraint(item: shareButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -8)
            let shareHeight = NSLayoutConstraint(item: shareButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            let shareWidth = NSLayoutConstraint(item: shareButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
            
            // add constraints of buttons to that view
            view.addConstraints([centerY,centerX,height,width,centerYmenu,leading,menuWidth,menuHeight,centerYshare,trailing,shareHeight,shareWidth])
            
            view.addSubview(saveButton)
            view.addSubview(menuButton)
            view.addSubview(shareButton)
            
            self.window!.addSubview(view)
        }
    }
    
    func toogleMenu() {
    }
    
    func shareWallpaper() {
    }
    
    func savePressed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getImage"), object: nil)
    }
    
    func showButtons(show: Bool) {
        if let window = window{
            if show {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: window.frame.height - 70, width: window.frame.width, height: 70)
                })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 70)
                })
            }
        }
    }
}

