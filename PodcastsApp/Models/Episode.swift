//
//  Episode.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/6/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import FeedKit

class Episode: NSObject, NSCoding, NSSecureCoding, Decodable {
    
    // NOTE : i changed description to describtion ...
    // to fix a weired bug i didnt understand but it looks like there is a conflict
    
    var title: String?
    var pubDate: Date? // episode date
    var describtion: String? // episode description
    var imageUrl: String? // image url
    var author: String?
    var streamUrl: String? // to get the audio url
    
    var fileUrl: String? // for offline download

    init(feedItem: RSSFeedItem) {
        // media object including in the items using enclosure
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
        self.title = feedItem.title ?? ""
        self.pubDate = feedItem.pubDate ?? Date()
        self.describtion = feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href ?? "" // imageUrl from xml rss feed
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
    }
    
    // NSSecureCoding
    static var supportsSecureCoding: Bool = true
    
    // NSCoding Funcs
    func encode(with coder: NSCoder) {
        coder.encode(title ?? "", forKey: "titleKey")
        coder.encode(pubDate ?? Date(), forKey: "pubDateKey")
        coder.encode(describtion ?? "", forKey: "descriptionKey")
        coder.encode(imageUrl ?? "", forKey: "imageUrlKey")
        coder.encode(author ?? "", forKey: "authorKey")
        coder.encode(streamUrl ?? "", forKey: "streamUrlKey")
        coder.encode(fileUrl, forKey: "fileUrlKey")
    }
    
    required init?(coder: NSCoder) {
        self.title = coder.decodeObject(forKey: "titleKey") as? String
        self.pubDate = coder.decodeObject(forKey: "pubDateKey") as? Date
        self.describtion = coder.decodeObject(forKey: "descriptionKey") as? String
        self.imageUrl = coder.decodeObject(forKey: "imageUrlKey") as? String
        self.author = coder.decodeObject(forKey: "authorKey") as? String
        self.streamUrl = coder.decodeObject(forKey: "streamUrlKey") as? String
        self.fileUrl = coder.decodeObject(forKey: "fileUrlKey") as? String
    }
    
    
}
