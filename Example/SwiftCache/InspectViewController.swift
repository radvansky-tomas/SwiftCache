//
//  InspectViewController.swift
//  SwiftCache
//
//  Created by Tomas Radvansky on 22/11/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import SwiftCache
import SwiftDate
import MGSwipeTableCell

class InspectViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    var data:[String:Array<CachedObject>] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.mainTableView.reloadData()
    }
    
    func loadData()
    {
        let allCachedObjects:Array<CachedObject> = SwiftCache.sharedInstance.getAllCachedObjects()
        
        let MimeTypes = allCachedObjects.map { (current:CachedObject) -> String in
            return current.MIMEType
        }
        
        for mime in MimeTypes
        {
            data[mime] = allCachedObjects.filter({ (current:CachedObject) -> Bool in
                return current.MIMEType == mime
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedKeys = self.data.keys.sorted()
        return self.data[sortedKeys[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let basicCell:MGSwipeTableCell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! MGSwipeTableCell
        let sortedKeys = self.data.keys.sorted()
        if let currentObject:CachedObject = self.data[sortedKeys[indexPath.section]]?[indexPath.row]
        {
            basicCell.textLabel?.text = (currentObject.timestamp as Date).string(dateStyle: .medium, timeStyle: .medium, in: nil)
            basicCell.detailTextLabel?.text = currentObject.url
            let deleteBtn = MGSwipeButton(title: "Delete", backgroundColor: UIColor.red)
            deleteBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
            deleteBtn.buttonWidth = 60.0
            deleteBtn.callback = {
                (sender: MGSwipeTableCell!) -> Bool in
                do
                {
                    try SwiftCache.sharedInstance.deleteCachedObject(url: currentObject.url)
                    self.loadData()
                    self.mainTableView.reloadSections(IndexSet.init(integer: indexPath.section), with: .automatic)
                }
                catch let error as NSError
                {
                    print(error)
                }
                return true
            }
            let refreshBtn = MGSwipeButton(title: "Refresh", backgroundColor: UIColor.blue)
            refreshBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10.0)
            refreshBtn.buttonWidth = 60.0
            refreshBtn.callback = {
                (sender: MGSwipeTableCell!) -> Bool in
                _ = SwiftCache.sharedInstance.loadResource(url: URL(string:currentObject.url)!, completionHandler: { (_, _) in
                    self.loadData()
                })
                return true
            }
            basicCell.rightButtons = [deleteBtn,refreshBtn]
        }
        return basicCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sortedKeys = self.data.keys.sorted()
        return sortedKeys[section]
    }
}
