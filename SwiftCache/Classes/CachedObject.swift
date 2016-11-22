//
//  CachedObject.swift
//  Pods
//
//  Created by Tomas Radvansky on 21/11/2016.
//
//

import Foundation
import RealmSwift
import Realm

public class CachedObject: Object {
    public dynamic var MIMEType:String = ""
    public dynamic var url:String = ""
    public dynamic var data:NSData = NSData()
    public dynamic var timestamp:NSDate = NSDate()
    
    override public static func primaryKey() -> String? {
        return "url"
    }
    
}
