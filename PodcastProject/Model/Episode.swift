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
    let author: String
    let streamUrl: String
    //it is var and opptional cuz sometimes doesnt exist
    var imageUrl: String?
    
    init(feedItem: RSSFeedItem) {
        //?? "" to unwrap it
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        //use this feedItem.iTunes?.iTunesSubtitle otherwise use feedItem.description
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.description ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href 
    }
}
