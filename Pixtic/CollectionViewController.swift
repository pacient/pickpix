//
//  CollectionViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 15/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Kingfisher

private let reuseIdentifier = "Cell"

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [Photo]?
    var isFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if images == nil {
            self.images = AppDelegate.instance().getStoredWallpapers()
            self.isFavourite = true
            collectionView.reloadData()
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WallpaperCell
        
        let resource = ImageResource(downloadURL: URL(string: (self.images?[indexPath.item].imageURL)!)!, cacheKey: self.images?[indexPath.item].photoID)
        cell.wallpaperImage.kf.setImage(with: resource, placeholder: nil, options: [], progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 124, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userInfo = ["atIndex" : indexPath.item, "favourites" : isFavourite] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getVC"), object: userInfo)
        self.dismiss(animated: true) {
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
        }
    }
    
    @IBAction func donePressed(_ sender: Any) {
        self.dismissView()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismissView()
    }
    
    func dismissView(){
        self.dismiss(animated: true) {
            AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
        }
    }
}
