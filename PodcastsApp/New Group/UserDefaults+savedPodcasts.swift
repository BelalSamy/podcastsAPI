//
//  UserDefaults+savedPodcasts.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/17/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
 
extension UserDefaults {
     
static let favoritedPodcastKey = "favoritedPodcastKey"
static let downloadedEpisodeKey = "downloadedEpisodeKey"


func downloadEpisode(episode: Episode) {
    do {
        // save array of episodes not just one object
        //var downloadedEpisodes = [Episode]() // every time it will append to empty array xxx
        //episodes.append(episode)
        
        var episodes = downloadedEpisodes()
        episodes.insert(episode, at: 0) // make episodes ordered descending
        
        let data = try NSKeyedArchiver.archivedData(withRootObject: episodes, requiringSecureCoding: true)
        
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
        
    } catch let error {
        print("Failed to save download episode : ", error)
    }
}
 

func downloadedEpisodes() -> [Episode] {
    do {
        guard let episodesData = UserDefaults.standard.data(forKey: UserDefaults.downloadedEpisodeKey) else { return [] }
        
        guard let downloadedEpisodes = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(episodesData) as? [Episode] else { return [] }
        
        return downloadedEpisodes
         
    } catch {
        return []
    }
}
    
    
func deleteDownloadedEpisode(episode: Episode) {
      let episodes = downloadedEpisodes()
      let filteredEpisodes = episodes.filter { (ep) -> Bool in
        return ep.title != episode.title && ep.author != episode.author
      }
        
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: filteredEpisodes, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
    } catch let error {
        print(error)
    }
}


func savedPodcasts() -> [Podcast] {
    do {
        //fetch our saved podcasts
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return [] }
        guard let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedPodcastsData) as? [Podcast] else { return [] }
        return savedPodcasts
        
        } catch {
            return []
        }
   }



func deletePodcast(podcast: Podcast) {
      let podcasts = savedPodcasts()
      let filteredPodcasts = podcasts.filter { (p) -> Bool in
        return p.trackName != podcast.trackName && p.artistName != podcast.artistName
      }
        
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: filteredPodcasts, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: UserDefaults.favoritedPodcastKey)
    } catch let error {
        print(error)
    }
}
    
    
    
}
