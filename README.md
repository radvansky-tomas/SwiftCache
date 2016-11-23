# SwiftCache

[![CI Status](http://img.shields.io/travis/Tomas Radvansky/SwiftCache.svg?style=flat)](https://travis-ci.org/Tomas Radvansky/SwiftCache)
[![Version](https://img.shields.io/cocoapods/v/SwiftCache.svg?style=flat)](http://cocoapods.org/pods/SwiftCache)
[![License](https://img.shields.io/cocoapods/l/SwiftCache.svg?style=flat)](http://cocoapods.org/pods/SwiftCache)
[![Platform](https://img.shields.io/cocoapods/p/SwiftCache.svg?style=flat)](http://cocoapods.org/pods/SwiftCache)

Basic caching library based on RealmDB. It allows to cache any type of URL resource and cache them separately based on MIME type inside Non-SQL database.

## How it works
SwiftCache library is utilizing one of the most common non-sql library - [RealmDB](https://realm.io/) and networking library purely written in swift - [Alamofire](https://github.com/Alamofire/Alamofire). Download requests are cached directly in database and separated by MIME type, which gives user ability to control cache more precisely.

## Usage
To access SwiftCache use singleton class
```swift
SwiftCache.sharedInstance
```

Main SwiftCache method to retrieve cached object is loadResource:
```swift
loadResource(url:URL, completionHandler:((_ result:CachedObject?, _ error:NSError?) -> Void)!)->String
```
NOTE: this method returns downloadRequest UUID, which you may use for its cancelation.

To clear cache programmaticaly you can you following method:
```swift
clearCache(MIMEType:String?) throws
```

NOTE: In case of nil MIMEtype, method clears whole cache. 

### Advanced usage
#### Pending Tasks
To cancel pending downloadRequest, you can use method:
```swift
cancelDownloadTask(taskID:String)
```

Or you can cancel or pending tasks by:
```swift
cancelAllDownloadTasks()
```

#### Cache size
To change default cache size - 10MB, you can use following method:
```swift
setCacheSize(size:Int64) throws
```
NOTE: NSError in case of invalid memory size. (negative size, or size bigger than available free memory)

#### Extensions
To fully utilize SwiftCache features you can extend class you need to support cache. As an example I provided UIImageView extension with simple method:

```swift
imageFromUrl(url:URL, placeholder:UIImage?)
```
#### Debugging
Debugging is disabled by default. It can be enabled by changing:
```swift
shouldDebug = true
```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
XCODE8
Swift3
iOS8.4 (Alamofire)

## Installation

SwiftCache is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SwiftCache"
```

## Author

Tomas Radvansky

## License

SwiftCache is available under the MIT license. See the LICENSE file for more info.

## 3rd party
Some ideas for example app has been taken from:
https://github.com/kyleclegg/SwiftFlickrSearch

[Alamofire](https://github.com/Alamofire/Alamofire)
[RealmDB](https://realm.io/)
