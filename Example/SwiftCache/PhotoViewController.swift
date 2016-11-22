//
//  PhotoViewController.swift
//  SwiftCache
//
//  Created by Tomas Radvansky on 11/21/2016.
//  Copyright (c) 2016 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

class PhotoViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var flickrPhoto: FlickrPhoto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if flickrPhoto != nil {
            photoImageView.imageFromUrl(url: flickrPhoto!.photoUrl as URL!, placeholder: UIImage(named:"spinner"))
        }
    }
    
}
