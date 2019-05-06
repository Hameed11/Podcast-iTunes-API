//
//  SearchTableViewController.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/5/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [
        Podcast(trackName: "Lets build an adudio app", artistName: "Mido hcj"),
        Podcast(trackName: "Lets build an app", artistName: " hcj")
    ]
    
    let cellId = "cellId"
    
    //1. implement a UISearchController
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()

    }
    
    fileprivate func setupSearchBar() {
        //2. implement a UISearchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        //when ever we type text in search bar we want to be notified - this lets us know what happens inside search bar
        searchController.searchBar.delegate = self
    }
    
    //MARK:- setup Work
    //3. implement a UISearchController
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        //implement Alamofire to search iTunes API
       // let url = "https://itunes.apple.com/search?term=\(searchText)"
        
        
        //filter search we only interested in podcast - "media": "podcast"
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]

        //URLEncoding.default will turn space between words in search to %20
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            if let err = dataResponse.error {
                print("failed to connect yahoo", err)
                return
            }
            
            guard let data = dataResponse.data else {
                return
            }
            print(data)
            
            
            do {
                
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                print("searchResult.resultCount", searchResult.resultCount)
                
                self.podcasts = searchResult.results
                self.tableView.reloadData()
                
            } catch let decodeErr {
                print("Failed to decode", decodeErr)
            }
        }
            
        }
        
    
    
    //4. implement a UISearchController
   // Decodable;  to transform json that we get form the api into Podcast model objects
    //to hold all our search result
    /*
     
     "results": [
     {"wrapperType":"track", "kind":"song", "artistId":272836694, "collectionId":273992420
 
    */
    struct SearchResults: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
    
    fileprivate func setupTableView() {
        //1. register a cell fro our tableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return podcasts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let podcast = podcasts[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = 0
        cell.imageView?.image =  #imageLiteral(resourceName: "appicon")

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
