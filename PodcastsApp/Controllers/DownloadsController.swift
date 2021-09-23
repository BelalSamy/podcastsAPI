//
//  DownloadsController.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/18/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit

class DownloadsController: UITableViewController {

    let cellId = "cellId"
    var episodes = UserDefaults.standard.downloadedEpisodes()

    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.downloadedEpisodes()
        tableView.reloadData()
        
        UIApplication.mainTabBarController()?.viewControllers?[2].tabBarItem.badgeValue = nil
    }
    
    //MARK:- Setup Funcs
    
    fileprivate func setupObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadProgress), name: .downloadProgress, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDownloadComplete), name: .downloadComplete, object: nil)
        
    }
    
    @objc fileprivate func handleDownloadComplete(notification: Notification) {
        guard let episodeDownloadComplete = notification.object as? APIService.EpisodeDownloadCompleteTuple else { return }
        
        guard let index = self.episodes.firstIndex(where: {$0.title ==
            episodeDownloadComplete.episodeTitle }) else { return }
        
        self.episodes[index].fileUrl = episodeDownloadComplete.fileUrl

    }
    
    @objc fileprivate func handleDownloadProgress(notification: Notification) {
        //print(123)
        guard let userInfo = notification.userInfo as? [String: Any] else { return }
        guard let progress = userInfo["progress"] as? Double else { return }//bec progress fraction is double
        guard let title = userInfo["title"] as? String else { return }
        
        // lets find the index using title
        guard let index = self.episodes.firstIndex(where: {$0.title == title}) else { return }
        // we need to have accesss to our cell to controll progress Label
        let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? EpisodeCell // section 0 bec only one
        
        // update the progress value
        let progressPercentage = "\( Int(progress * 100) )%"
        cell?.progressLabel.text = progressPercentage
        cell?.progressLabel.isHidden = false
        
        if progress == 1 {
            // if the progresss is complepted 100%
            cell?.progressLabel.isHidden = true
        }
    }
    
    fileprivate func setupTableView() {
        
        // background color
        tableView.backgroundColor = .white
        
        // to remove the lines of table view
        tableView.separatorStyle = .none
    
        // to do it with nib
        /*let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId) */
        
        // to do it with class
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: cellId)
    }
    
    
    //MARK:- TableView Funcs
    
    // number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    // cell for row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        cell.episode = self.episodes[indexPath.row]
        return cell
    }

    // height for row
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // did select row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        print("launch episode player offline : ", episode.fileUrl ?? "nil")
        if episode.fileUrl != nil {
           UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
        } else {
            
            let alertController = UIAlertController(title: "File URL not found", message: "Cannot find local file, play online instead ?!", preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                UIApplication.mainTabBarController()?.maximizePlayerDetails(episode: episode, playlistEpisodes: self.episodes)
            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            }))
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // swipe actions for row
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
    let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {  (_, _, _) in
        //Code I want to do here
        let episode = self.episodes[indexPath.row]
        self.episodes.remove(at: indexPath.row) //remove the actual object from the array
        self.tableView.deleteRows(at: [indexPath], with: .automatic) //then remove it from tableview
        UserDefaults.standard.deleteDownloadedEpisode(episode: episode) //remove it from userdefaults
        tableView.reloadData()
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    

/*
     // deprecated code ....
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
        }
        return [deleteAction]
    }*/
    
    
}
