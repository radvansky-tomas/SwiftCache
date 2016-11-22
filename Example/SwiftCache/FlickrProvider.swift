//
//  FlickrProvider.swift
//  SwiftCache
//
//  Created by Tomas Radvansky on 11/21/2016.
//  Copyright (c) 2016 Tomas Radvansky. All rights reserved.
//

import Foundation
import SwiftCache

class FlickrProvider {
    
    typealias FlickrResponse = (NSError?, [FlickrPhoto]?) -> Void
    
    struct Keys {
        static let flickrKey = "0461b2b85aee5a025189ce3eed1aff6b"
    }
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    class func fetchPhotosForSearchText(searchText: String, onCompletion: @escaping FlickrResponse) -> Void {
        let escapedSearchText: String = searchText.addingPercentEncoding(withAllowedCharacters:.urlHostAllowed)!
        let urlString: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Keys.flickrKey)&tags=\(escapedSearchText)&per_page=25&format=json&nojsoncallback=1"
        
        _ = SwiftCache.sharedInstance.loadResource(url: URL(string:urlString)!,  completionHandler: { (object:CachedObject?, error:NSError?) in
            if let error:NSError = error
            {
                print("Error fetching photos: \(error)")
                onCompletion(error, nil)
                return
            }
            else
            {
                if let cachedObject:CachedObject = object
                {
                    do {
                        let resultsDictionary = try JSONSerialization.jsonObject(with: cachedObject.data as Data, options: []) as? [String: AnyObject]
                        guard let results = resultsDictionary else { return }
                        
                        if let statusCode = results["code"] as? Int {
                            if statusCode == Errors.invalidAccessErrorCode {
                                let invalidAccessError = NSError(domain: "com.flickr.api", code: statusCode, userInfo: nil)
                                onCompletion(invalidAccessError, nil)
                                return
                            }
                        }
                        
                        guard let photosContainer = resultsDictionary!["photos"] as? NSDictionary else { return }
                        guard let photosArray = photosContainer["photo"] as? [NSDictionary] else { return }
                        
                        let flickrPhotos: [FlickrPhoto] = photosArray.map { photoDictionary in
                            
                            let photoId = photoDictionary["id"] as? String ?? ""
                            let farm = photoDictionary["farm"] as? Int ?? 0
                            let secret = photoDictionary["secret"] as? String ?? ""
                            let server = photoDictionary["server"] as? String ?? ""
                            let title = photoDictionary["title"] as? String ?? ""
                            
                            let flickrPhoto = FlickrPhoto(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                            return flickrPhoto
                        }
                        
                        onCompletion(nil, flickrPhotos)
                        
                    } catch let error as NSError {
                        print("Error parsing JSON: \(error)")
                        onCompletion(error, nil)
                        return
                    }

                }
            }
        })
    }
    
}
