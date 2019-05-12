//
//  PlayerDetailsView.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/11/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit
import AVKit

class PlayerDetailsView: UIView {
    
    var episode: Episode! {
        didSet {
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
        }
    }
    
    fileprivate func playEpisode() {
        print("Trying to play episode at url:", episode.streamUrl)
        
        guard let url = URL(string: episode.streamUrl) else { return }
        //an item to play
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
        player.play()
    }
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        //to make it play faster
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    // MARK:_ IB Actions & Outlets
    
    @IBAction func handleDismiss(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    

    
    @IBOutlet weak var episodeImageView: UIImageView!
    
    @IBOutlet weak var authorLabel: UILabel!
   
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            //create an action
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        print("trying to play and pause")
        playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        if player.timeControlStatus == .paused {
            player.play()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    
    
    
    
    
}
