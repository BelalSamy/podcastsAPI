//
//  RSSFeed.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/9/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import FeedKit

extension RSSFeed {
    
    func toEpisodes() -> [Episode] {
        var episodes = [Episode]() // empty arr for episodes
        
        items?.forEach({ (feedItem) in // iterate through items array .. to get episodes
            print(feedItem.title ?? "")
            let episode = Episode(feedItem: feedItem)
            episodes.append(episode)
        })
        
        return episodes
    }
}
