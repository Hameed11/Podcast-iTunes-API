//
//  RSSFeed.swift
//  PodcastProject
//
//  Created by Hameed Abdullah on 5/11/19.
//  Copyright © 2019 Hameed Abdullah. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeed {
    
    func topEpisode() -> [Episode] {
        let imageUrl = iTunes?.iTunesImage?.attributes?.href
        
        var episodes = [Episode]() //an empty array of Episode
        
        items?.forEach({ (feedItem) in
            var episode = Episode(feedItem: feedItem)
            
            //if we cant get episode image then podcast image(imageUrl)
            //Whenever we are not able to locate an episode image, we'll go ahead and use the podcast image url.
            if episode.imageUrl == nil {
                episode.imageUrl = imageUrl
            }
            
            episodes.append(episode)
        })
        
        return episodes
        
    }
}
