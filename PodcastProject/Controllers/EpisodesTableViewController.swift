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
                    let episode = Episode(feedItem: feedItem)
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

    
    var episodes = [Episode]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
//        navigationItem.title = "Episodes"

    }
    
    //MARK:- Setup TableView
    fileprivate func setupTableView() {
    
        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
        //to remove lines in tableView
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        // Configure the cell...
        let episode = episodes[indexPath.row]
        
        cell.episode = episode

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }



}
