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
        
        APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
            self.episodes = episodes
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
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
    
    //MARK:- 1. startAnimating activityIndecator
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndecatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndecatorView.color = .darkGray
        activityIndecatorView.startAnimating()
        return activityIndecatorView
    }
    
    //MARK:- 2. Stop activityIndecator
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        //if empty show 200 else retun height 0 so we cant see it(activityIndecator)
        return episodes.isEmpty ? 200 : 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = episodes[indexPath.row]
         let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.maximizePlayerDetails(episode: episode)
        /*let episode = episodes[indexPath.row]
        print("Tryong to pay episode;", episode.title)
        
        //get access to applocation's window
        let window = UIApplication.shared.keyWindow
        
        //load playerDetailView from xib file
        let playerDetailView = PlayerDetailsView.initFromNib()
        
        playerDetailView.episode = episode
        
        playerDetailView.frame = self.view.frame
        window?.addSubview(playerDetailView)*/
    }

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
