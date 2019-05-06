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
    }
    
    //MARK:_ Setup function
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
