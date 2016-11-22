//
//  FlickrPhoto.swift
//  SwiftCache
//
//  Created by Tomas Radvansky on 11/21/2016.
//  Copyright (c) 2016 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

struct FlickrPhoto {
    
    let photoId: String
    let farm: Int
    let secret: String
    let server: String
    let title: String
    
    var photoUrl: NSURL {
        return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_m.jpg")!
    }
    
}
