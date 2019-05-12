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
    
    var podcasts = [Podcast]()
    
    let cellId = "cellId"
    
    //1. implement a UISearchController
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        
        searchBar(searchController.searchBar, textDidChange: "Voong")

    }
    
    fileprivate func setupSearchBar() {
        
        //to show title properly on EpisodesTableViewController set it to true
        self.definesPresentationContext = true
        
        //2. implement a UISearchController
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        //when ever we type text in search bar we want to be notified - this lets us know what happens inside search bar
        searchController.searchBar.delegate = self
    }
    
    //MARK:- setup Work
    //3. implement a UISearchController
    //searchText parameter is the text we are searching
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        //MARK:_ the order of call
        print(1)
        APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
            self.podcasts = podcasts
            self.tableView.reloadData()
        }
        
    }
    
    
    
    fileprivate func setupTableView() {
        
        //to remove lines in tableView
        tableView.tableFooterView = UIView()
        
        //1. register a cell fro our tableView
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        //1. register a cell fro our tableView
        //7.L
        //"PodcastCell" swift file name should matches
        let nib = UINib(nibName: "PodcastCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let episodesTableViewController = EpisodesTableViewController()
        let podcast = podcasts[indexPath.row]
        episodesTableViewController.podcast = podcast
        navigationController?.pushViewController(episodesTableViewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //if podcasts array count is greater than zeron return height 0 else return height 250 - ternary operator
        return self.podcasts.count > 0 ? 0 : 250
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return podcasts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell

        let podcast = podcasts[indexPath.row]
        cell.podcast = podcast
        
//        let podcast = podcasts[indexPath.row]
//        // Configure the cell...
//        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
//        cell.textLabel?.numberOfLines = 0
//        cell.imageView?.image =  #imageLiteral(resourceName: "appicon")

        return cell
    }
    
    //7.L give cells tall height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
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
