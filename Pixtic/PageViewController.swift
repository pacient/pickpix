//
//  PageViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 06/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import GoogleMobileAds

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, GADInterstitialDelegate {
    
    var imageURLs: [String]!
    var interstitial: GADInterstitial!
    
    var interstitialTestAdID = "ca-app-pub-3940256099942544/4411468910"
    var bannerLiveAdID = "ca-app-pub-9037734016404410/7744729286"
    var interstitialLiveAdID = "ca-app-pub-9037734016404410/3057177684"
    
    var previousCounter = 0
    var nextCounter = 0
    
    var isFavourite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        dataSource = self
        
        let bannerView = AppDelegate.instance().bannerAd
        bannerView.adUnitID = bannerLiveAdID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        interstitial = createAndLoadInterstitial()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getFirstVC), name: NSNotification.Name(rawValue: "getVC"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(noInternet), name: NSNotification.Name(rawValue: "noInternet"), object: nil)
    }
    
    func noInternet() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "noIntVC")
        vc.loadView()
        self.present(vc, animated: false, completion: nil)
    }
    
    func getFirstVC(notification: Notification) {
        let userInfo = notification.object as! [String : Any]
        let atIndex = userInfo["atIndex"] as! Int
        self.isFavourite = userInfo["favourites"] as! Bool
        if self.isFavourite{
            AppDelegate.instance().images = AppDelegate.instance().getStoredWallpapers().reversed()
        }
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallpaperVC") as! WallpaperViewController
        firstViewController.loadView()
        firstViewController.actIndc.startAnimating()
        firstViewController.photo = AppDelegate.instance().images[atIndex]
        let url = URL(string: firstViewController.photo.imageURL!)!
        let resource = ImageResource(downloadURL: url, cacheKey: firstViewController.photo.photoID!)
        firstViewController.imageView.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder-1"), options: [], progressBlock: nil, completionHandler: { (img, error, _, _) in
            if img != nil {
                firstViewController.actIndc.stopAnimating()
                AppDelegate.instance().addButtonView()
                AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
                
            }
        })
        self.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? WallpaperViewController {
            
            if let currentIndex = AppDelegate.instance().images.index(of: vc.photo){
                
                if currentIndex < AppDelegate.instance().images.count - 1 {
                    let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallpaperVC") as! WallpaperViewController
                    nextViewController.loadView()
                    nextViewController.actIndc.startAnimating()
                    nextViewController.photo = AppDelegate.instance().images[currentIndex + 1]
                    let url = URL(string: AppDelegate.instance().images[currentIndex + 1].imageURL)
                    let resource = ImageResource(downloadURL: url!, cacheKey: AppDelegate.instance().images[currentIndex + 1].photoID!)
                    nextViewController.imageView.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder-1"), options: [], progressBlock: nil, completionHandler: { (img, error, _, _) in
                        if img != nil {
                            nextViewController.actIndc.stopAnimating()
                            self.nextCounter += 1
                        }
                    })
                    if ((self.nextCounter + 1) % 10 == 0) && self.nextCounter > 0 {
                        if interstitial.isReady{
                            AppDelegate.instance().showButtons(show: false, moveBannerAd: true)
                            interstitial.present(fromRootViewController: self)
                            self.nextCounter = 0
                            self.previousCounter = 0
                        }
                    }
                    return nextViewController
                }
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let vc = viewController as? WallpaperViewController{
            
            if let currentIndex = AppDelegate.instance().images.index(of: vc.photo){
                
                if currentIndex > 0 {
                    let previousViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallpaperVC") as! WallpaperViewController
                    previousViewController.loadView()
                    previousViewController.actIndc.startAnimating()
                    previousViewController.photo = AppDelegate.instance().images[currentIndex - 1]
                    let url = URL(string: AppDelegate.instance().images[currentIndex - 1].imageURL)
                    let resource = ImageResource(downloadURL: url!, cacheKey: AppDelegate.instance().images[currentIndex - 1].photoID!)
                    previousViewController.imageView.contentMode = .scaleToFill
                    previousViewController.imageView.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder-1"), options: [], progressBlock: nil, completionHandler: { (img, error, _, _) in
                        if img != nil {
                            previousViewController.actIndc.stopAnimating()
                            self.previousCounter += 1
                        }
                    })
                    if ((self.previousCounter + 1) % 10 == 0) && self.previousCounter > 0 {
                        if interstitial.isReady{
                            AppDelegate.instance().showButtons(show: false, moveBannerAd: true)
                            interstitial.present(fromRootViewController: self)
                            self.previousCounter = 0
                            self.nextCounter = 0
                        }
                    }
                    return previousViewController
                }
            }
        }
        
        return nil
    }
    
    //MARK: Interstitial Delegate
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
        AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: interstitialTestAdID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    
}
