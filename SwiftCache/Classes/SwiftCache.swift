import UIKit
import Foundation
import Alamofire
import RealmSwift
import FCUUID

@objc public class SwiftCache: NSObject {
    
    var pendingRequests:[String:DownloadRequest] = [:]
    var maxCacheSize:Int = 200000
    
    let realm = try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "MyInMemoryRealm"))
    
    //MARK:- Instance
    @objc public class var sharedInstance :SwiftCache {
        struct Singleton {
            static let instance = SwiftCache()
        }
        return Singleton.instance
    }
    
    public func loadResource(url:URL, completionHandler:((_ result:CachedObject?, _ error:NSError?) -> Void)!)->String
    {
        let taskID:String = FCUUID.uuid()
        if let data = isResourceCached(url: url)
        {
            //Try to update timestamp
            do
            {
                try self.realm.write {
                    data.timestamp = NSDate()
                }
            }
            catch let error as NSError
            {
                print(error)
            }
            completionHandler(data, nil)
        }
        else
        {
            let destination: DownloadRequest.DownloadFileDestination = { url, response in
                var documentsURL:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                documentsURL.appendPathComponent(url.lastPathComponent)
                print(documentsURL)
                return (documentsURL, [.removePreviousFile, .createIntermediateDirectories])
            }
            
            
            let request = Alamofire.download(url,to:destination).downloadProgress(closure: { (progress:Progress) in
                //Here i need to check if image was not cached in meantime
                if (self.isResourceCached(url: url) != nil)
                {
                    self.cancelDownloadTask(taskID: taskID)
                }
            }).responseData { (dataResponse) in
                
                if let responseError = dataResponse.result.error
                {
                    completionHandler(nil, responseError as NSError?)
                }
                else
                {
                    let objectToCache = CachedObject()
                    objectToCache.MIMEType = dataResponse.response?.allHeaderFields["Content-Type"] as! String
                    objectToCache.url=dataResponse.response!.url!.absoluteString
                    objectToCache.data = dataResponse.result.value as! NSData
                    
                    do
                    {
                        try self.cacheObject(object: objectToCache)
                        completionHandler(objectToCache, nil)
                    }
                    catch let error as NSError
                    {
                        //if there is cached object we can return it
                        completionHandler(self.isResourceCached(url: url), error)
                    }
                }
                self.pendingRequests.removeValue(forKey: taskID)
            }
            self.pendingRequests[taskID] = request
        }
        return taskID
    }
    
    public func cancelDownloadTask(taskID:String)
    {
        self.pendingRequests[taskID]?.cancel()
    }
    
    public func cancelAllDownloadTasks()
    {
        for task in self.pendingRequests.values
        {
            task.cancel()
        }
    }
    
    func isResourceCached(url:URL)->CachedObject?
    {
        let cachedObjects = realm.objects(CachedObject.self).filter("url = %@", url.absoluteString)
        if let object:CachedObject = cachedObjects.first
        {
            if !object.isInvalidated
            {
                return object
            }
        }
        return nil
    }
    
    public func getCacheSize(MIMEType:String) -> Int
    {
        var cacheSize:Int = 0
        let cachedObjects = realm.objects(CachedObject.self).filter("MIMEType = %@", MIMEType)
        for object in cachedObjects
        {
            cacheSize = cacheSize + object.data.length
        }
        return cacheSize
    }
    
    func cacheObject(object:CachedObject) throws
    {
        try realm.write {
            while getCacheSize(MIMEType:object.MIMEType) + object.data.length > maxCacheSize
            {
                if let cachedObject = realm.objects(CachedObject.self).sorted(byProperty: "timestamp").last
                {
                    print("Delete - \(cachedObject.url) for MIME: \(object.MIMEType)")
                    realm.delete(cachedObject)
                }
            }
            realm.add(object, update: true)
            
        }
        print("Cache Size:\(getCacheSize(MIMEType: object.MIMEType)) for MIME: \(object.MIMEType)")
    }
}
