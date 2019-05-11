//
//  Episode.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/10/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import Foundation
import FeedKit

struct Episode {
    let title: String
    let pubDate: Date
    let description: String
    
    //it is var and opptional cuz sometimes doesnt exist
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.description = feedItem.description ?? ""
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href 
    }
}
