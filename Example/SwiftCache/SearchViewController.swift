//
//  ViewController.swift
//  FlickrSearch
//
//  Created by Kyle Clegg on 12/09/14.
//  Copyright (c) 2014 Kyle Clegg. All rights reserved.
//

import UIKit
import PullToRefresh
import SwiftCache

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let refresher = PullToRefresh()
    var photos: [FlickrPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.addPullToRefresh(refresher) {
            if self.searchBar.text != nil
            {
                if self.searchBar.text!.characters.count > 0
                {
                    //This should empty cache:
                    do
                    {
                        try SwiftCache.sharedInstance.clearCache(MIMEType: nil)
                    }
                    catch let error as NSError
                    {
                        print(error)
                    }
                    self.performSearchWithText(searchText: self.searchBar.text!)
                }
            }
            self.tableView.endRefreshing(at: .top)
        }
    }
    
    deinit {
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResultCellIdentifier = "SearchResultCell"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: searchResultCellIdentifier, for: indexPath as IndexPath) as? SearchResultCell
        cell!.setupWithPhoto(flickrPhoto: photos[indexPath.row])
        return cell!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "PhotoSegue", sender: self)
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //Reenable Cancel button:
        if let cancelBtn:UIButton = searchBar.value(forKey: "_cancelButton") as? UIButton
        {
            cancelBtn.isEnabled = true
        }
        performSearchWithText(searchText: searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        photos.removeAll(keepingCapacity: false);
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
        self.title = "Flickr Search"
    }
    
    // MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PhotoSegue" {
            let photoViewController = segue.destination as! PhotoViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow
            photoViewController.flickrPhoto = photos[selectedIndexPath!.row]
        }
        
    }
    
    // MARK: - Private
    
    private func performSearchWithText(searchText: String) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        FlickrProvider.fetchPhotosForSearchText(searchText: searchText, onCompletion: { (error: NSError?, flickrPhotos: [FlickrPhoto]?) -> Void in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                self.photos = flickrPhotos!
            } else {
                self.photos = []
                if (error!.code == FlickrProvider.Errors.invalidAccessErrorCode) {
                    DispatchQueue.main.async(execute: { () -> Void in
                        self.showErrorAlert()
                    })
                }
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadSections(IndexSet.init(integer: 0), with: .automatic)
            })
        })
    }
    
    private func showErrorAlert() {
        let alertController = UIAlertController(title: "Search Error", message: "Invalid API Key", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(dismissAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}
