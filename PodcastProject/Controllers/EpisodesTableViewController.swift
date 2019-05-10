//
//  EpisodesTableViewController.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/9/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit
import FeedKit

class EpisodesTableViewController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            
            fetchEpisodes()
            print(podcast?.feedUrl)
        }
    }
    
    fileprivate func fetchEpisodes() {
        print("Looking for espisodes at feed url:", podcast?.feedUrl ?? "")
        
        guard let feedUrl = podcast?.feedUrl else { return }
        
        let secureFeedUrl = feedUrl.contains("https") ? feedUrl : feedUrl.replacingOccurrences(of: "http", with: "https")
        
        guard let url = URL(string: secureFeedUrl) else { return}
        let parser = FeedParser(URL: url)
        
        parser.parseAsync { (result) in

            var episodes = [Episode]() //an empty array of Episode
            
            // Associative enumeration values
            switch result {
            case let .rss(feed):
                feed.items?.forEach({ (feedItem) in
                    let episode = Episode(title: feedItem.title ?? "")
                    episodes.append(episode)
                })
                
                self.episodes = episodes
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                break
            case let .failure(error):
                print("Failed to parse feed:", error)
                break
            default:
                //this could be atom, json - that one we deleted cuz we dont need them we are just parsing rss
                print("Found a feed...")
            }
            
        }
    }
    
    fileprivate let cellId = "cellId"
    
    struct Episode {
        let title: String
    }
    
    var episodes = [
        Episode(title: "First Episode"),
        Episode(title: "Second Episode"),
        Episode(title: "Third Episode"),
        Episode(title: "Fourth Episode")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
//        navigationItem.title = "Episodes"

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    //MARK:- Setup TableView
    fileprivate func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        //to remove lines in tableView
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        // Configure the cell...
        let e = episodes[indexPath.row]
        cell.textLabel?.text = e.title

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
