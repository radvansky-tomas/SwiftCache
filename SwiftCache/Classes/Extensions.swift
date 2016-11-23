//
//  Extensions.swift
//  Pods
//
//  Created by Tomas Radvansky on 22/11/2016.
//
//

import Foundation

//Simple example how to extend existing controls
//to support SwiftCache library
public extension UIImageView
{
    /**
     Function to load image resource from remote source using SwiftCache
     - parameters:
        - url: Remote location
        - placeholder: Optional UIImage placeholder
     */
    func imageFromUrl(url:URL, placeholder:UIImage?) {
        self.image = placeholder
        SwiftCache.sharedInstance.loadResource(url: url, completionHandler: { (object:CachedObject?, error:NSError?) in
            if let error:NSError = error
            {
                if SwiftCache.sharedInstance.shouldDebug
                {
                    print(error)
                }
            }
            else
            {
                if let cachedObject:CachedObject = object
                {
                    self.image = UIImage(data: cachedObject.data as Data)
                }
            }
        })
    }
}
