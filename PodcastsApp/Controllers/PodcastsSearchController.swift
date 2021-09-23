//
//  SearchController.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/4/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import UIKit
import Alamofire

class PodcastsSearchController: UITableViewController, UISearchBarDelegate {
    
    let cellId = "cellId"
    
//    var podcasts = [
//        Podcast(trackName: "Lets Build That App", artistName: "Brian Voong"),
//        Podcast(trackName: "Some Podcast", artistName: "Some Author"),
//    ]
    
    var podcasts = [Podcast]()
    
    // lets implement a UISearchController
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.backgroundColor = .yellow

        setupSearchBar()
        setupTableView()
        
        //searchBar(searchController.searchBar, textDidChange: "hazem")
        
    }
    
    //MARK:- Setup Funcs
    
    fileprivate func setupSearchBar() {
        // add search controller to navigation bar
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = false // to make everything still white
        searchController.searchBar.delegate = self
    }
    
    
    
    var timer: Timer?
    // search bar text didChange ...
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print(searchText)
        
        timer?.invalidate()
        
        // make a delay to fix podcasts flickering
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            
             // implement alamofire to search itunes api
             APIService.shared.fetchPodcasts(searchText: searchText) { (podcasts) in
                 print("finished searching for podcasts ...")
                 self.podcasts = podcasts
                 self.tableView.reloadData()
             }
            
        })
    }
    

    //1. register a cell for out tableview ...  // .self bec it expect class type
    fileprivate func setupTableView() {
    
    // to remove the lines of table view
    tableView.separatorStyle = .none

    tableView.register(PodcastCell.self, forCellReuseIdentifier: cellId)
        
    // to register a custom cell
    //let nib = UINib(nibName: "PodcastCell", bundle: nil)
    //tableView.register(nib, forCellReuseIdentifier: cellId)
        
    }
    
    
    //MARK:- TableView Funcs
    
    //2. how many cells to return
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    //3 return specifc item for row at indexpath
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        //cell.backgroundColor = .red
        
        /*
        let podcast = self.podcasts[indexPath.row]
        cell.textLabel?.text = "\(podcast.trackName ?? "")\n\(podcast.artistName ?? "")"
        cell.textLabel?.numberOfLines = 0 // zero or -1 to have infinite number of lines
        cell.imageView?.image = #imageLiteral(resourceName: "appicon")
        */
        
        let podcast = self.podcasts[indexPath.row]
        cell.podcast = podcast
        
        return cell
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132 // bec the height of image is 100 + 16 top padding + 16 bottom padding
    }
    
    // did select
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)

        let episodesController = EpisodesController()
        let podcast = self.podcasts[indexPath.row]
        episodesController.podcast = podcast
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    //MARK:- TABLEVIEW HEADER FUNCS
    
    // header for empty
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Please enter a Search Term"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }
    
    // height for header
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // ternary operator >>> condition ? true : false
        return self.podcasts.count > 0 ? 0 : 250
    }

    
}
