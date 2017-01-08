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

    @IBAction func savePressed(_ sender: Any) {
        self.savedView.layer.cornerRadius = 10
        self.savedView.layer.masksToBounds = true
        
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
        UIView.animate(withDuration: 0.3) {
            self.savedView.alpha = 0.90
        }
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            UIView.animate(withDuration: 0.3, animations: {
                self.savedView.alpha = 0
            })
        }
    }
}

