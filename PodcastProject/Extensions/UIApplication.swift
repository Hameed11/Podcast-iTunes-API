//
//  UIApplication.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/18/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import UIKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
}
