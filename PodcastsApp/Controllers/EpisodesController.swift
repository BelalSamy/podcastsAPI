//
//  EpisodesController.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/6/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import UIKit
import SDWebImage
import FeedKit

class EpisodesController: UITableViewController{
    
    let cellId = "cellId"
    var episodes = [Episode]()
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
            print(podcast?.feedUrl ?? "")
        }
    }
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        //navigationItem.title = "Episodes"
        setupTableView()
        fetchEpisodes()
        setupNavigationBarButtons()
        
        setupObserver()
    }
    
    
    fileprivate func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
       guard let userInfo = notification.userInfo as? [String: Any] else { return }
       guard let progress = userInfo["progress"] as? Double else { return }//bec progress fraction is double
       
       // update the progress value
       let progressPercentage = "\( Int(progress * 100) )%"
       UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = progressPercentage
       
       if progress == 1 {
           // if the progresss is complepted 100%
           UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = "new"
       }
    }

    
//MARK:- Fetch Episodes
fileprivate func fetchEpisodes() {
    print("Looking for episodes at feed url : ", podcast?.feedUrl ?? "")
    guard let feedUrl = podcast?.feedUrl else { return }
    APIService.shared.fetchEpisodes(feedUrl: feedUrl) { (episodes) in
        self.episodes = episodes
        // table view must reload in main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
    
    //MARK:- Setup Funcs
    fileprivate func setupTableView() {
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
    }
    
    fileprivate func setupNavigationBarButtons() {
  
       // check if we have already saved this podcast as fav
       let savedPodcasts = UserDefaults.standard.savedPodcasts()
       let hasFavorited = savedPodcasts.firstIndex(where: {$0.trackName == podcast?.trackName && $0.artistName == podcast?.artistName}) != nil
        
        if hasFavorited {
            // setting up our heart icon
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite").withRenderingMode(.alwaysOriginal), style: .plain, target: nil, action: nil)
        } else {
            navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(handleSaveFavorite)),
            //UIBarButtonItem(title: "Fetch", style: .plain, target: self, action: #selector(handleFetchSavedPodcasts))
            ]
        }
        
    }
    
    
    @objc fileprivate func handleSaveFavorite() {
        
        print("saving info into userDefaults")
        guard let podcast =  self.podcast else { return }
        //UserDefaults.standard.set(podcast.trackName, forKey: favoritePodcastKey)
        
        // transform podcast into data
        do {
        // saving array of podcasts objects
        var listOfPodcasts = UserDefaults.standard.savedPodcasts()
        listOfPodcasts.append(podcast)
    
        let data = try NSKeyedArchiver.archivedData(withRootObject: listOfPodcasts, requiringSecureCoding: true)
        UserDefaults.standard.set(data , forKey: UserDefaults.favoritedPodcastKey)
            
        showBadgeHighlight()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite"), style: .plain, target: nil, action: nil)

        } catch let error {
            print("Failed to save info into userDefaults : ", error)
        }

    }
    
    fileprivate func showBadgeHighlight() {
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = "New"
    }
    

    @objc fileprivate func handleFetchSavedPodcasts() {
        print("Fetching saved podcasts from UserDefaults")
        //let value = UserDefaults.standard.value(forKey: favoritePodcastKey) as? String
        //print(value ?? "")
        
        // how to retrieve our podcast object from user defaults
        guard let data = UserDefaults.standard.data(forKey: UserDefaults.favoritedPodcastKey) else { return }
        
        do {
        //let podcast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Podcast
        let savedPodcasts = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Podcast]
            savedPodcasts?.forEach({ (podcast) in
                print(podcast.trackName ?? "", podcast.artistName ?? "")
            })
            
            //print(podcast?.trackName ?? "", podcast?.artistName ?? "")
        } catch let error {
            print("Failed to retrieve info from userDefaults : ", error)
        }
 
        
    }
    
    //MARK:- TableView Funcs
    
    // cell for row at
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        //cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let episode = episodes[indexPath.row]
        UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode,
                                                                    playlistEpisodes: self.episodes )
        
        /*let playerDetailsView = PlayerDetailsView()
        playerDetailsView.modalPresentationStyle = .fullScreen
        let episode = episodes[indexPath.row]
        playerDetailsView.episode = episode
        present(playerDetailsView, animated: true, completion: nil)*/
    }
    
    let progressPercentage: String? = nil
    // swipe actions for row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let downlaodAction = UIContextualAction(style: .normal, title: "Download") {  (_, _, _) in
        //Code I want to do here
        print("Downloading episodes into UserDefaults")
        let episode = self.episodes[indexPath.row]
        UserDefaults.standard.downloadEpisode(episode: episode)

        // download the podcast episode using Alamofire
        APIService.shared.downloadEpisode(episode: episode)
        tableView.setEditing(false, animated: true) // to back to normal after click 
    }
        let swipeActions = UISwipeActionsConfiguration(actions: [downlaodAction])
        return swipeActions
    }
    
    /* edit actions for row >>> swipe to download >>>>> deprecated code
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
        }
        return [downloadAction]
    }*/
    
    //MARK:-  footer
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    // footer height
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
}
