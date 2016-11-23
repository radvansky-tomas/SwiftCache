//
//  CachedObject.swift
//  Pods
//
//  Created by Tomas Radvansky on 21/11/2016.
//
//

import Foundation
import RealmSwift

/**
 Main entity for SwiftCache
 */
public class CachedObject: Object {
    public dynamic var MIMEType:String = ""
    public dynamic var url:String = ""
    public dynamic var data:NSData = NSData()
    //Used for cache optimization
    public dynamic var timestamp:NSDate = NSDate()
    
    /**
     Optional method for RealmDB to setup primaryKeys within DB
     - Returns: Primary key (property name)
     */
    override public static func primaryKey() -> String? {
        return "url"
    }
}
