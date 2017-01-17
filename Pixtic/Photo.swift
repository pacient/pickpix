//
//  Photo.swift
//  Pixtic
//
//  Created by Vasil Nunev on 07/01/2017.
//  Copyright © 2017 nunev. All rights reserved.
//

import UIKit

class Photo: NSObject, NSCoding {

    var photoID: String!
    var imageURL: String!
    var date: Date!
    
    override init() {
        super.init()
    }
    
    init(photoIDs: String, imageURLs: String, dates: Date) {
        self.photoID = photoIDs
        self.imageURL = imageURLs
        self.date = dates
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let photoIDs = aDecoder.decodeObject(forKey: "photoID") as! String
        let imageURLs = aDecoder.decodeObject(forKey: "imageURL") as! String
        let dates = aDecoder.decodeObject(forKey: "date") as! Date
        self.init(photoIDs: photoIDs,imageURLs: imageURLs,dates: dates)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(photoID, forKey: "photoID")
        aCoder.encode(imageURL, forKey: "imageURL")
        aCoder.encode(date, forKey: "date")
    }
}
