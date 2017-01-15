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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AppDelegate.instance().images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! WallpaperCell
        
        let resource = ImageResource(downloadURL: URL(string: AppDelegate.instance().images[indexPath.item].imageURL)!, cacheKey: AppDelegate.instance().images[indexPath.item].photoID)
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
        return CGSize(width: (self.view.frame.width/3)-1, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getVC"), object: indexPath.item)
        self.dismiss(animated: true) {
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true) {
            AppDelegate.instance().showButtons(show: true, moveBannerAd: true)
            UIApplication.shared.setStatusBarHidden(true, with: .slide)
        }
    }
    
}
