//
//  Extensions.swift
//  Pods
//
//  Created by Tomas Radvansky on 22/11/2016.
//
//

import Foundation

public extension UIImageView
{
    func imageFromUrl(url:URL, placeholder:UIImage?) {
        self.image = placeholder
        SwiftCache.sharedInstance.loadResource(url: url, completionHandler: { (object:CachedObject?, error:NSError?) in
            if let error:NSError = error
            {
                print(error)
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
