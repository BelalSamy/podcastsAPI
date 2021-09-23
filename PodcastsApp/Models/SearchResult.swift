//
//  SearchResult.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/4/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation

//. docadable
struct SearchResults: Decodable {
    let resultCount: Int
    let results: [Podcast] // array of podcast objcs + make the class decodable to make it works
}
