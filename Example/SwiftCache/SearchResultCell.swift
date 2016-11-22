//
//  SearchResultCell.swift
//  SwiftCache
//
//  Created by Tomas Radvansky on 11/21/2016.
//  Copyright (c) 2016 Tomas Radvansky. All rights reserved.
//

import Foundation
import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var resultTitleLabel: UILabel!
    @IBOutlet weak var resultImageView: UIImageView!
    
    func setupWithPhoto(flickrPhoto: FlickrPhoto) {
        resultTitleLabel.text = flickrPhoto.title
        resultImageView.imageFromUrl(url: flickrPhoto.photoUrl as URL!, placeholder: UIImage(named:"spinner"))
    }
    
}
