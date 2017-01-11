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

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var imageURLs: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        dataSource = self
        
        let bannerView = AppDelegate.instance().bannerAd
        bannerView.adUnitID = "ca-app-pub-9037734016404410/7744729286"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        NotificationCenter.default.addObserver(self, selector: #selector(getFirstVC), name: NSNotification.Name(rawValue: "getVC"), object: nil)
        
    }
    
    func getFirstVC() {
        let firstViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallpaperVC") as! WallpaperViewController
        firstViewController.loadView()
        firstViewController.photo = AppDelegate.instance().images.first!
        let url = URL(string: AppDelegate.instance().images.first!.imageURL!)!
        let resource = ImageResource(downloadURL: url, cacheKey: AppDelegate.instance().images.first!.photoID!)
        firstViewController.imageView.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: [], progressBlock: nil, completionHandler: { (img, error, _, _) in
            if img != nil {
                AppDelegate.instance().addButtonView()
                AppDelegate.instance().showButtons(show: true)
            }
        })
        self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! WallpaperViewController
        
        if let currentIndex = AppDelegate.instance().images.index(of: vc.photo){
            
            if currentIndex < AppDelegate.instance().images.count - 1 {
                let nextViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallpaperVC") as! WallpaperViewController
                nextViewController.loadView()
                nextViewController.photo = AppDelegate.instance().images[currentIndex + 1]
                let url = URL(string: AppDelegate.instance().images[currentIndex + 1].imageURL)
                let resource = ImageResource(downloadURL: url!, cacheKey: AppDelegate.instance().images[currentIndex + 1].photoID!)
                nextViewController.imageView.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: [], progressBlock: nil, completionHandler: { (img, error, _, _) in
                    if img != nil {
                    }
                })
                return nextViewController
            }
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! WallpaperViewController
        
        if let currentIndex = AppDelegate.instance().images.index(of: vc.photo){
            
            if currentIndex > 0 {
                let previousViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "wallpaperVC") as! WallpaperViewController
                previousViewController.loadView()
                previousViewController.photo = AppDelegate.instance().images[currentIndex - 1]
                let url = URL(string: AppDelegate.instance().images[currentIndex - 1].imageURL)
                let resource = ImageResource(downloadURL: url!, cacheKey: AppDelegate.instance().images[currentIndex - 1].photoID!)
                previousViewController.imageView.contentMode = .scaleToFill
                previousViewController.imageView.kf.setImage(with: resource, placeholder: #imageLiteral(resourceName: "placeholder"), options: [], progressBlock: nil, completionHandler: { (img, error, _, _) in
                    if img != nil {
                    }
                })
                return previousViewController
            }
        }
        
        return nil
    }
}
