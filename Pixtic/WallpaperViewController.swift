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
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func savePressed(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, nil, nil, nil)
    }
    
}

