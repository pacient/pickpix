//
//  AppDelegate.swift
//  Pixtic
//
//  Created by Vasil Nunev on 05/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var images: [Photo]!
    var currentImage: UIImage!
    let view = UIView()
    let topView = UIView()
    let favButton = UIButton()
    let bannerAd = GADBannerView()
    
    var isFavourite = false
    var currentWallpaper: Photo!
    
    var ref:FIRDatabaseReference!
    var added = false
    
    class func instance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        GADMobileAds.configure(withApplicationID: "ca-app-pub-9037734016404410~4791262881")
        ref = FIRDatabase.database().reference()
        
        print(UIDevice.current.modelName)
        
        getWallpapersFromDatabase()
        
        return true
    }
    
    //MARK: GET request calls
    func getWallpapersFromDatabase() {
        if isInternetAvailable(){
            ref.child("iphone6").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                if let categories = snapshot.value as? [String : AnyObject] {
                    self.images = [Photo]()
                    for (_, wallpapers) in categories{
                        if let imgs = wallpapers as? [String : AnyObject]{
                            for (id,url) in imgs {
                                if id != "icon"{
                                    let photo = Photo()
                                    photo.photoID = id
                                    photo.imageURL = url["imageURL"] as! String
                                    let dateStr = url["date"] as! String
                                    let dateFmt = DateFormatter()
                                    dateFmt.timeZone = TimeZone.current
                                    dateFmt.dateFormat = "dd-MM-yyyy"
                                    photo.date = dateFmt.date(from: dateStr)
                                    self.images.append(photo)
                                }
                                let sorted = self.images.sorted { $0.date > $1.date }
                                self.images = sorted
                            }
                        }
                    }
                    let userInfo = ["atIndex" : 0, "favourites" : false] as [String : Any]
                    if !(self.window?.rootViewController?.isKind(of: PageViewController.classForCoder()))!{
                        self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getVC"), object: userInfo)
                }
            })
            ref.removeAllObservers()
        }
    }
    
    func getWallpapers(from categoryName: String){
        if categoryName == "All" {
            getWallpapersFromDatabase()
        }else {
            if isInternetAvailable(){
                ref.child("iphone6").child(categoryName).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let wallpapers = snapshot.value as? [String : AnyObject] {
                        self.images = [Photo]()
                        for (id,url) in wallpapers {
                            if id != "icon" {
                                let photo = Photo()
                                photo.photoID = id
                                photo.imageURL = url["imageURL"] as! String
                                let dateStr = url["date"] as! String
                                let dateFmt = DateFormatter()
                                dateFmt.timeZone = TimeZone.current
                                dateFmt.dateFormat = "dd-MM-yyyy"
                                photo.date = dateFmt.date(from: dateStr)
                                self.images.append(photo)
                            }
                        }
                        let sorted = self.images.sorted { $0.date > $1.date }
                        self.images = sorted
                        
                        let userInfo = ["atIndex" : 0, "favourites" : false] as [String : Any]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getVC"), object: userInfo)
                    }
                })
                ref.removeAllObservers()
            }
        }
    }
    
    //MARK: Application Functions
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
    
    //MARK: Useful Functions
    func addButtonView() {
        if let window = window {
            if !added {
                view.backgroundColor = UIColor.clear
                view.frame = CGRect(x: 0, y: window.frame.height - 120, width: window.frame.width, height: 70)
                
                //save button
                let saveButton = UIButton()
                saveButton.frame = CGRect(x: view.frame.width / 2, y: view.frame.height / 2, width: 50, height: 50)
                saveButton.addTarget(self, action: #selector(self.savePressed), for: .touchUpInside)
                saveButton.setImage(#imageLiteral(resourceName: "180 - iPhone 6 Plus"), for: .normal)
                saveButton.translatesAutoresizingMaskIntoConstraints = false
                
                let centerX = NSLayoutConstraint(item: saveButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
                let centerY = NSLayoutConstraint(item: saveButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                let height = NSLayoutConstraint(item: saveButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
                let width = NSLayoutConstraint(item: saveButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
                
                // menu button
                let menuButton = UIButton()
                menuButton.addTarget(self, action: #selector(toogleMenu), for: .touchUpInside)
                menuButton.setImage(#imageLiteral(resourceName: "menuPNG"), for: .normal)
                menuButton.translatesAutoresizingMaskIntoConstraints = false
                
                let centerYmenu = NSLayoutConstraint(item: menuButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                let leading = NSLayoutConstraint(item: menuButton, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 8)
                let menuHeight = NSLayoutConstraint(item: menuButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
                let menuWidth = NSLayoutConstraint(item: menuButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
                
                //share button
                let shareButton = UIButton()
                shareButton.addTarget(self, action: #selector(shareWallpaper), for: .touchUpInside)
                shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
                shareButton.translatesAutoresizingMaskIntoConstraints = false
                
                let centerYshare = NSLayoutConstraint(item: shareButton, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
                let trailing = NSLayoutConstraint(item: shareButton, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -8)
                let shareHeight = NSLayoutConstraint(item: shareButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
                let shareWidth = NSLayoutConstraint(item: shareButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
                
                bannerAd.frame = CGRect(x: 0, y: view.frame.origin.y + 70, width: window.frame.width, height: 50)
                
                let y = NSLayoutConstraint(item: bannerAd, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
                
                // add constraints of buttons to that view
                view.addConstraints([centerY,centerX,height,width,centerYmenu,leading,menuWidth,menuHeight,centerYshare,trailing,shareHeight,shareWidth,y])
                
                view.addSubview(saveButton)
                view.addSubview(menuButton)
                view.addSubview(shareButton)
                view.addSubview(bannerAd)
                
                
                //create the top buttons
                topView.backgroundColor = UIColor.clear
                topView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 70)
                
                //Collection view button
                let collectionButton = UIButton()
                collectionButton.addTarget(self, action: #selector(openCollectionView), for: .touchUpInside)
                collectionButton.setImage(#imageLiteral(resourceName: "collectionView"), for: .normal)
                collectionButton.translatesAutoresizingMaskIntoConstraints = false
                
                let trailingCollection = NSLayoutConstraint(item: collectionButton, attribute: .trailing, relatedBy: .equal, toItem: self.favButton, attribute: .leading, multiplier: 1, constant: -8)
                let centerCollection = NSLayoutConstraint(item: collectionButton, attribute: .centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1, constant: 0)
                let collectionHeight = NSLayoutConstraint(item: collectionButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
                let collectionWidth = NSLayoutConstraint(item: collectionButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
                
                //Favourite button
                self.favButton.addTarget(self, action: #selector(favPressed), for: .touchUpInside)
                self.checkIfFavourite()
                self.favButton.translatesAutoresizingMaskIntoConstraints = false
                
                let favTrailing = NSLayoutConstraint(item: self.favButton, attribute: .trailing, relatedBy: .equal, toItem: topView, attribute: .trailing, multiplier: 1, constant: -16)
                let centerFav = NSLayoutConstraint(item: self.favButton, attribute: .centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1, constant: 0)
                let favHeight = NSLayoutConstraint(item: self.favButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
                let favWidth = NSLayoutConstraint(item: self.favButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
                
                topView.addConstraints([trailingCollection,centerCollection,collectionWidth,collectionHeight,favWidth,favHeight,centerFav,favTrailing])
                
                topView.addSubview(collectionButton)
                topView.addSubview(self.favButton)
                
                self.window!.addSubview(topView)
                self.window!.addSubview(view)
                self.window!.addSubview(bannerAd)
                self.added = true
            }
        }
    }
    
    func favPressed() {
        if !isFavourite{
            if let photo: Photo = self.currentWallpaper{
                var storedWallpapers = getStoredWallpapers()
                
                storedWallpapers.append(photo)
                let dataWp = NSKeyedArchiver.archivedData(withRootObject: storedWallpapers)
                UserDefaults.standard.set(dataWp, forKey: "savedWallpaper")
                UserDefaults.standard.synchronize()
                checkIfFavourite()
            }
        }else {
            if let photo = self.currentWallpaper {
                var storedWallpapers = getStoredWallpapers()
                for (index,each) in storedWallpapers.enumerated() {
                    if each.photoID == photo.photoID {
                        storedWallpapers.remove(at: index)
                        break
                    }
                }
                
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: storedWallpapers), forKey: "savedWallpaper")
                UserDefaults.standard.synchronize()
                checkIfFavourite()
            }
            
        }
    }
    
    func getStoredWallpapers() -> [Photo] {
        var storedWallpapers: [Photo]
        if let storedWallpapersData = UserDefaults.standard.object(forKey: "savedWallpaper") as? Data {
            storedWallpapers = NSKeyedUnarchiver.unarchiveObject(with: storedWallpapersData) as! [Photo]
        }else {
            storedWallpapers = [Photo]()
        }
        return storedWallpapers
    }
    
    func checkIfFavourite() {
        var storedWallpapers: [Photo]
        if let storedWallpapersData = UserDefaults.standard.object(forKey: "savedWallpaper") as? Data {
            storedWallpapers = NSKeyedUnarchiver.unarchiveObject(with: storedWallpapersData) as! [Photo]
            if storedWallpapers.count > 0 {
                for each in storedWallpapers{
                    if each.photoID! == self.currentWallpaper.photoID{
                        self.isFavourite = true
                        break
                    }else{
                        self.isFavourite = false
                    }
                }
            }else {
                self.isFavourite = false
            }
        }
        if isFavourite {
            self.favButton.setImage(#imageLiteral(resourceName: "favouriteSelected-1"), for: .normal)
        }else{
            self.favButton.setImage(#imageLiteral(resourceName: "favourite-1"), for: .normal)
        }
    }
    
    func openCollectionView() {
        
        let collectionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "collectionVC") as! CollectionViewController
        collectionVC.images = self.images
        
        UIApplication.shared.setStatusBarHidden(false, with: .slide)
        self.window!.rootViewController!.present(collectionVC, animated: true, completion: nil)
        self.showButtons(show: false, moveBannerAd: true)
    }
    
    func toogleMenu() {
        let vc = UIStoryboard(name: "Menu", bundle: nil).instantiateInitialViewController()
        
        if let window = window{
            showButtons(show: false, moveBannerAd: true)
            window.rootViewController?.present(vc!, animated: false, completion: nil)
        }
    }
    
    func shareWallpaper() {
        if window != nil {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "currentImage"), object: nil)
            let activityViewController = UIActivityViewController(activityItems: [self.currentImage], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.window
            self.showButtons(show: false, moveBannerAd: true)
            activityViewController.completionWithItemsHandler = { _, _, _, _ in
                self.showButtons(show: true, moveBannerAd: true)
            }
            self.window!.rootViewController!.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    func savePressed() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getImage"), object: nil)
    }
    
    func showButtons(show: Bool, moveBannerAd: Bool) {
        if let window = window{
            if show {
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: window.frame.height - 120, width: window.frame.width, height: 70)
                    self.topView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: 70)
                    if moveBannerAd{
                        self.bannerAd.frame = CGRect(x: 0, y: self.view.frame.origin.y + 70, width: window.frame.width, height: 50)
                    }
                })
            }else{
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: 70)
                    self.topView.frame = CGRect(x: 0, y: -70, width: window.frame.width, height: 70)
                    if moveBannerAd {
                        self.bannerAd.frame = CGRect(x: 0, y: self.view.frame.origin.y + 70, width: window.frame.width, height: 50)
                    }
                })
            }
        }
    }
}
