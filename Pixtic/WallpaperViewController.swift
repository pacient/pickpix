//
//  WallpaperViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 05/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Kingfisher
import Photos

class WallpaperViewController: UIViewController {
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var savedView: UIView!
    
    @IBOutlet weak var actIndc: UIActivityIndicatorView!
    var photo: Photo!
    
    var buttonsHidden = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currentImage), name: NSNotification.Name(rawValue: "getImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getImage), name: NSNotification.Name(rawValue: "currentImage"), object: nil)

        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
        
        actIndc.hidesWhenStopped = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func doubleTapped() {
        AppDelegate.instance().showButtons(show: !buttonsHidden, moveBannerAd: false)
        buttonsHidden = !buttonsHidden
    }
    
    func getImage() {
        AppDelegate.instance().currentImage = self.imageView.image
    }
    
    func currentImage() {
        if PHPhotoLibrary.authorizationStatus() == .authorized{
            AppDelegate.instance().currentImage = self.imageView.image
            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, self, #selector(imageSaved(image:didFinishSavingWithError:contextInfo:)), nil)
        }else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                let alertView = UIAlertController(title: "No Access", message: "Wallpapers can't be saved because access to photos was denied. To give access press Settings and turn ON the switcher on photos", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                    let settingsUrl = URL(string:UIApplicationOpenSettingsURLString)
                    if let url = settingsUrl {
                        UIApplication.shared.openURL(url)
                    }
                }
                alertView.addAction(settingsAction)
                alertView.addAction(okAction)
                self.present(alertView, animated: true, completion: nil)
            })
        }
    }

    func imageSaved(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: CGContext?){
        if didFinishSavingWithError == nil {
            showSavedView()
        }else {
            let alert = UIAlertController(title: "Error", message: "Something went wrong and your wallpaper was not saved. Please try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showSavedView() {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        container.backgroundColor = UIColor.black
        container.alpha = 0.0
        container.center = self.view.center
        container.layer.cornerRadius = 10
        container.layer.masksToBounds = true
        
        let savedLabel = UILabel()
        savedLabel.frame = container.frame
        savedLabel.text = "Saved"
        savedLabel.textColor = UIColor.white
        savedLabel.textAlignment = .center
        savedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerX = NSLayoutConstraint(item: savedLabel, attribute: .centerX, relatedBy: .equal, toItem: container, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: savedLabel, attribute: .centerY, relatedBy: .equal, toItem: container, attribute: .centerY, multiplier: 1, constant: 0)
        
        container.addConstraints([centerY,centerX])
        container.addSubview(savedLabel)
        
        self.view.addSubview(container)
        
        
        UIView.animate(withDuration: 0.3) {
            container.alpha = 0.90
        }
        let when = DispatchTime.now() + 1.2
        DispatchQueue.main.asyncAfter(deadline: when){
            UIView.animate(withDuration: 0.3, animations: {
                container.alpha = 0
            })
        }
    }
}

