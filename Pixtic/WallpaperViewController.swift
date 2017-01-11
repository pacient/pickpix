//
//  WallpaperViewController.swift
//  Pixtic
//
//  Created by Vasil Nunev on 05/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit
import Kingfisher

class WallpaperViewController: UIViewController {
    
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var savedView: UIView!
    
    var photo: Photo!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.currentImage), name: NSNotification.Name(rawValue: "getImage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.getImage), name: NSNotification.Name(rawValue: "currentImage"), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func getImage() {
        AppDelegate.instance().currentImage = self.imageView.image
    }
    
    func currentImage() {
        AppDelegate.instance().currentImage = self.imageView.image
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        showSavedView()
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

