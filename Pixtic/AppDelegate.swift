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


}

