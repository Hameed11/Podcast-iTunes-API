//
//  MainTabBarController.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/5/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit

//MARK:_ Step 1
//MARK:_ MainTabBarController
class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make title of viewController Large
        UINavigationBar.appearance().prefersLargeTitles = true
        
        //color of tabBar images
        tabBar.tintColor = .purple
        
        setupViewControllers()
        
     
        setupPlayerDetailsView()
        
        ////MARK:- 3. Maximizing and Minimizing Player Animations
        //1 second
        //perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1)
    }
    
    
    @objc func minimizePlayerDetails() {
        //disable the top anchor
        maximizedTopAnchorConstrait.isActive = false
        bottomAnchorConstrait.constant = view.frame.height
        //minimized top anchor down below
        minimizedTopAnchorConstrait.isActive = true
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            //21.L
            //show tabBar - sets the animated view to its original place
            self.tabBar.transform = .identity
            
            //22.L
            //set to 0 to hide it when we are minimizing
            self.playerDetailsview.maximizedStackView.alpha = 0
            self.playerDetailsview.miniPlayerView.alpha = 1
        })
    }
    
     func maximizePlayerDetails(episode: Episode?) {
        minimizedTopAnchorConstrait.isActive = false
        maximizedTopAnchorConstrait.isActive = true
        maximizedTopAnchorConstrait.constant = 0
        
        
        //bring it back to 0
        bottomAnchorConstrait.constant = 0
        
        if episode != nil {
            playerDetailsview.episode = episode
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.layoutIfNeeded()
            
            //21.L
            //hide tabBar
            self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
            
            //22.L
            self.playerDetailsview.maximizedStackView.alpha = 1
            //set to 0 to hide it when we are maximizing
            self.playerDetailsview.miniPlayerView.alpha = 0
        })
    }
    
    
    //MARK:_ Setup function
    
    
    //MARK:- 1. Maximizing and Minimizing Player Animations
    //! cuz i know it will not be nil
     let playerDetailsview = PlayerDetailsView.initFromNib()
    
    var maximizedTopAnchorConstrait: NSLayoutConstraint!
    var minimizedTopAnchorConstrait: NSLayoutConstraint!
    var bottomAnchorConstrait: NSLayoutConstraint!
       //MARK:- 2. Maximizing and Minimizing Player Animations
    fileprivate func setupPlayerDetailsView() {
        print("setting up playerDetailsview")
        
        //use auto layou
        //add it to Subview before auto layout anchoring otherwise it will crash
        //adding view to sub view it will be added on top of it
        //view.addSubview(playerDetailsview)
        
        //add playerDetailsview below tabBar
        view.insertSubview(playerDetailsview, belowSubview: tabBar)
        
        //= false enables auto layout
        //setup 4 anchors
        //isActive to activate constraint
        playerDetailsview.translatesAutoresizingMaskIntoConstraints = false
        
        maximizedTopAnchorConstrait =  playerDetailsview.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height)
       
        maximizedTopAnchorConstrait.isActive = true
        
        bottomAnchorConstrait =  playerDetailsview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
        
        bottomAnchorConstrait.isActive = true

       
        
        minimizedTopAnchorConstrait = playerDetailsview.topAnchor.constraint(equalTo: tabBar.topAnchor, constant: -64)
       // minimizedTopAnchorConstrait.isActive = true
        
        
        playerDetailsview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        //trailing the right side
        playerDetailsview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        
    }
    
    func setupViewControllers() {
        
        //an array of viewControllers for tabBar
        viewControllers = [
             generateNavigationController(with: SearchTableViewController(), title: "Search", image: #imageLiteral(resourceName: "search")),
            generateNavigationController(with: ViewController(), title: "Favorites", image: #imageLiteral(resourceName: "favorites")),
            generateNavigationController(with: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
        ]
    }
    
    
    //MARK:_ Helper Function
    fileprivate func generateNavigationController(with rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        //title of viewController on nav
        rootViewController.navigationItem.title = title
        
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        
        return navController
        
    }
}
