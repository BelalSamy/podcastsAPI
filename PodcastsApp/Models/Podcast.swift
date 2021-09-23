 //
//  Podcast.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/4/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation

 class Podcast: NSObject, NSCoding, NSSecureCoding, Decodable {
    
    // make it optional bec if write something wrong it will be nil and it will fail to decode 
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String? // image url
    var trackCount: Int? // number of episodes
    var feedUrl: String? // url contains all episodes for podcast
    
    // NSSecureCoding
    static var supportsSecureCoding: Bool = true
    
    // NSCoding Funcs
    func encode(with coder: NSCoder) {
        //print("Trying to transform podcast into Data")
        coder.encode(artworkUrl600 ?? "", forKey: "artworkKey")
        coder.encode(trackName ?? "", forKey: "trackNameKey")
        coder.encode(artistName ?? "", forKey: "artistNameKey")
        // feed url
        coder.encode(feedUrl ?? "", forKey: "feedUrlKey")

    }
    
    required init?(coder: NSCoder) {
         //print("Trying to turn Data into Podcast object again")
         self.artworkUrl600 = coder.decodeObject(forKey: "artworkKey") as? String
         self.trackName = coder.decodeObject(forKey: "trackNameKey") as? String
         self.artistName = coder.decodeObject(forKey: "artistNameKey") as? String
         // feed url
         self.feedUrl = coder.decodeObject(forKey: "feedUrlKey") as? String
    }
    
    
 }
