//
//  APIService.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/4/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import Alamofire
import FeedKit

extension Notification.Name {
    static let downloadProgress = NSNotification.Name("downloadProgress")
    static let downloadComplete = NSNotification.Name("downloadComplete")
}

class APIService {
    
    typealias EpisodeDownloadCompleteTuple = (fileUrl: String, episodeTitle: String)
    
    let baseiTunesSearchURL = "https://itunes.apple.com/search"
    // singleton
    static let shared = APIService()
    
    //MARK:- Download
    func downloadEpisode(episode: Episode) {
        print("Downloading episode using Alamofire , at stream url : ", episode.streamUrl ?? "")
        
        let downloadRequest = DownloadRequest.suggestedDownloadDestination()
        Alamofire.download(episode.streamUrl ?? "", to: downloadRequest).downloadProgress { (progress) in
            //print(progress.fractionCompleted * 100, "%")
            
            // i want to notify DownloadController about my download progress
            // you can post some information for another class
            NotificationCenter.default.post(name: .downloadProgress, object: nil, userInfo: ["title": episode.title ?? "", "progress": progress.fractionCompleted])
            
            
            
        }.response { (response) in
            print(response.destinationURL?.absoluteString ?? "")
            
            // create object from typealias
            let episodeDownloadComplete = EpisodeDownloadCompleteTuple(fileUrl: response.destinationURL?.absoluteString ?? "",
                episodeTitle: episode.title ?? "")
                
            NotificationCenter.default.post(name: .downloadComplete, object: episodeDownloadComplete, userInfo: nil)
            
            // update userdefaults with this new array that had file url on it
            do {
            
            // i want to update UserDefaults downloaded episodes with this temp file somehow
            let downloadedEpisodes = UserDefaults.standard.downloadedEpisodes()
            guard let index = downloadedEpisodes.firstIndex(where: {$0.title == episode.title && $0.author == episode.author}) else { return } // to get the index

            // save the location in file url variable
            downloadedEpisodes[index].fileUrl = response.destinationURL?.absoluteString ?? ""
            
            
                let data = try NSKeyedArchiver.archivedData(withRootObject: downloadedEpisodes, requiringSecureCoding: true)
                UserDefaults.standard.set(data, forKey: UserDefaults.downloadedEpisodeKey)
            } catch let error {
                print("Failed to save downloaded episodes with file url update : ", error)
            }
        }
    }
    
    
    //MARK:- Fetch Episodes
    func fetchEpisodes(feedUrl: String, completionHandler: @escaping ([Episode]) -> ()) {
        //guard let feedUrl = podcast?.feedUrl else { return }
        guard let url = URL(string: feedUrl.toSecureHTTPS()) else { return }
        
        // fix : fetch all that code in background thread so we dont block the ui
        // bec it takes couple of seconds before the episodes show up
        DispatchQueue.global(qos: .background).async {
             
            print("before parser")
            let parser = FeedParser(URL: url)
            print("after parser")
            
            parser.parseAsync { (result) in
                switch result {
                // success
                case .success(let feed):
                    print("Sucessfully parse feed ( rss ) : ", feed)
                    
                    guard let RSSFeed = feed.rssFeed else { return }
                    let episodes = RSSFeed.toEpisodes() // refactor with RSSFeed extension
                    completionHandler(episodes)
                    
                // failure
                case .failure(let error):
                    print("failed to parse feed : ", error)
                }
            }
        }
    }
    
    //MARK:- Fetch Podcasts
    func fetchPodcasts(searchText: String,   completionHandler: @escaping ([Podcast]) -> ()) {
        print("Searching for podcasts ... ")

        //1. url
        //let url = "https://itunes.apple.com/search?term=jack+johnson"
        //let url = "https://itunes.apple.com/search?term=\(searchText)" // string interpolation
        //let url = "https://itunes.apple.com/search"
        
        let parameters = ["term": searchText, "media": "podcast"]
            
        //2. request
        Alamofire.request(baseiTunesSearchURL, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            
            //3. failed
            if let err = dataResponse.error {
                print("Failed to contact yahoo : ", err)
                return
            }
            
            //4. success
            guard let data = dataResponse.data else { return }
            //let dummyString = String(data: data, encoding: .utf8)
            //print(dummyString ?? "")
            
            //6. JSONDecoder
            do {
                // using json decode to turn raw data into swift objc
                let searchResult = try JSONDecoder().decode(SearchResults.self, from: data)
                //print(searchResult.resultCount)
                
                //7. get the data
                completionHandler(searchResult.results)

                /*print("Result Count : ", searchResult.resultCount)
                searchResult.results.forEach { (podcast) in
                    print(podcast.artistName, podcast.trackName)
                }*/
                
                
            } catch let decodeErr {
                print("Failed to decode : ", decodeErr)
            }
            
        }
        
        
        //. docadable
        struct SearchResults: Decodable {
            let resultCount: Int
            let results: [Podcast] // array of podcast objcs + make the class decodable to make it works
        }
        
        
    }
}

