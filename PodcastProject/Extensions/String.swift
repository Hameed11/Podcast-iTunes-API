//
//  String.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/11/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import Foundation

//we can create any of function will be availabe in all type of Strings throughtout the entire project
extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
