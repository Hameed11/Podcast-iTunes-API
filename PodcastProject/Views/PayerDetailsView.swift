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
            miniTitleLabel.text = episode.title
            titleLabel.text = episode.title
            authorLabel.text = episode.author
            
            playEpisode()
            
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url)
            miniEpisodeImageView.sd_setImage(with: url)
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
    
    ///MARK:-  3. has Retain Cycle
    // fixed by adding [weak self] and add ? to all selfs - player will stop when we hit the button dismiss
    //Prepares the receiver for service after it has been loaded from an Interface Builder archive, or nib file.
    fileprivate func observePlayerCurrentTime() {
        //we'll use a Periodic Observer to monitor the play time of our AVPlayer object
        let interval = CMTimeMake(value: 1, timescale: 2)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            self?.currentTimeLabel.text = time.toDisplayString()
            
            let durationTime = self?.player.currentItem?.duration
            self?.durationLabel.text = durationTime?.toDisplayString()
            
            //on storyboard set slider value to 0, mini 0, maxi 1
            self?.updateCurrentTimeSlider()
        }
    }
    
    fileprivate func updateCurrentTimeSlider() {
        
        //use the current time of player devided by the duration time
        let currentTimeSeconds = CMTimeGetSeconds(player.currentTime())
        let durationSeconds = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
        
        let percentage = currentTimeSeconds / durationSeconds
        self.currentTimeSlider.value = Float(percentage)
    }
    
    //to access it in any method
    var panGesture: UIPanGestureRecognizer!
    
    fileprivate func setupGestures() {
        //21.L 1.
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapMaximize)))
        
        //MARK:- Drag & drop mini Player
        //MARK:- Drag and Drop UIPanGesture Recognizer Pt.1
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        miniPlayerView.addGestureRecognizer(panGesture)
        
        //Player Dismissal on Drag 25.L
        maximizedStackView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleDismissalPan)))
    }
    
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .changed {
            //grab translation
            let translation = gesture.translation(in: superview)
            maximizedStackView.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if gesture.state == .ended {
            let translation = gesture.translation(in: superview)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                //get it back to the top
                self.maximizedStackView.transform = .identity
                
                if translation.y > 200 {
                    let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
                    mainTabBarController?.minimizePlayerDetails()
                }
                
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGestures()
        
        observePlayerCurrentTime()
        
       
        //Monitor the player when it starts
        let time = CMTimeMake(value: 1, timescale: 3)
        let times = [NSValue(time: time)]
        
        //MARK:-  1. has Retain Cycle
        // player has a reference to self
        // self has a reference to player
        // the fix added  [weak self] in and ? after self self?
        player.addBoundaryTimeObserver(forTimes: times, queue: .main) { [weak self] in
            print("Episode started playing")
            self?.enlargeEpisodeImageView()
        }
    }
    
    //MARK:- Drag and Drop UIPanGesture Recognizer Pt.1
    @objc func handlePan(gesture: UIPanGestureRecognizer) {
        print("Panning")
        
//        if gesture.state == .began {
//            print("Began")
//        }
        
        if gesture.state == .changed {
            handlePanChanged(gesture: gesture)
            
        } else if gesture.state == .ended {
      
            handlePanEnded(gesture: gesture)
        }
        
    }
    
    func handlePanChanged(gesture: UIPanGestureRecognizer) {
        print("Changed")
        //translationX: 0 cuz we are not moving it horizantally
        //translation to bring it up
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        print(translation.y)
        
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    func handlePanEnded(gesture: UIPanGestureRecognizer) {
        print("ended")
        
        let translation = gesture.translation(in: self.superview)
        
        //to drag the play quickly
        let velocity = gesture.velocity(in: self.superview)
        print("ended:", translation.y, velocity.y)
        
        //whenever the gesture ends will animate entire view back to down to the bottom
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            
            //maximize the player to top
            if translation.y < -200  || velocity.y < -500 {
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
                
            } else {
                //minimize the player to the bottom
                self.miniPlayerView.alpha = 1
                //set it to 0 so it will be hidden
                self.maximizedStackView.alpha = 0
            }
            
            
        })
    }
    
    static func initFromNib() -> PlayerDetailsView {
        return Bundle.main.loadNibNamed("PlayerDetailsView", owner: self, options: nil)?.first as! PlayerDetailsView
    }
    
    //21.L gets called when we tap on the PlayerDetailsView UI
    @objc func handleTapMaximize() {
    
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: nil)
        
    }
    
    //MARK:-  3. to test Retain Cycle override deintit method
    // called after pressing the button dismiss
    deinit {
        print("PlayerDetailsView memory being reclaimed...")
    }
    
    // MARK:_ IB Actions & Outlets
    
    @IBOutlet weak var miniEpisodeImageView: UIImageView!
    @IBOutlet weak var miniTitleLabel: UILabel!
    
    @IBOutlet weak var miniPlayerPauseButton: UIButton! {
        didSet {
            miniPlayerPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var miniFastForwardButton: UIButton!
    
    
    @IBOutlet weak var miniPlayerView: UIView!
    @IBOutlet weak var maximizedStackView: UIStackView!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeSlider: UISlider!
    
    @IBAction func handleCurrentTimeChanged(_ sender: Any) {
        print("Slider value:", currentTimeSlider.value)
        
        let percentage = currentTimeSlider.value
        
        guard let duration = player.currentItem?.duration else { return }
        let durationInSeconds = CMTimeGetSeconds(duration)
        
        let seekTimeInSeconds = Float64(percentage) * durationInSeconds
        let seekTime = CMTimeMakeWithSeconds(seekTimeInSeconds, preferredTimescale: 1)
        player.seek(to: seekTime)
    }
    
    fileprivate func seekToCurrentTime(delta: Int64) {
        let fifteenSeconds = CMTimeMake(value: delta, timescale: 1)
        let seekTime = CMTimeAdd(player.currentTime(), fifteenSeconds)
        player.seek(to: seekTime)
    }
    //18.L
    @IBAction func handleRewind(_ sender: Any) {
       seekToCurrentTime(delta: -15)
    }
    
    //18.L
    @IBAction func handleFastForward(_ sender: Any) {
        seekToCurrentTime(delta: 15)
    }
    
   
    //21.L -  minimizePlayerDetails() called from MainTabBarController class using UIApplication.shared
    @IBAction func handleDismiss(_ sender: UIButton) {
       //self.removeFromSuperview()
       let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController
        mainTabBarController?.minimizePlayerDetails()
        
    }
    
    //18.L
    //on UI Builder change value to 1
    @IBAction func handleVolumeChanged(_ sender: UISlider) {
        player.volume = sender.value
    }
    
    
    
    
    
    //17.L
    fileprivate func enlargeEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            self.episodeImageView.transform = .identity
            
        })
    }

    fileprivate let shrunkenTransform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    
    fileprivate func shrinkEpisodeImageView() {
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            
            self.episodeImageView.transform = self.shrunkenTransform
            
        })
    }
    
    @IBOutlet weak var episodeImageView: UIImageView! {
        didSet {
            episodeImageView.layer.cornerRadius = 5
            episodeImageView.clipsToBounds = true
            
            episodeImageView.transform = shrunkenTransform
        }
    }
    
    @IBOutlet weak var authorLabel: UILabel!
   
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
             playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            //create an action
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    @objc func handlePlayPause() {
        print("trying to play and pause")
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            miniPlayerPauseButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            enlargeEpisodeImageView()
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            miniPlayerPauseButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            shrinkEpisodeImageView()
        }
    }
    
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.numberOfLines = 2
        }
    }
    
    
    
    
    
}
