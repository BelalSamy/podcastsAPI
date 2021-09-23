//
//  MainTabBarController.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/4/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let playerView = PlayerDetailsView()
    var maximizedTopAnchorConstraint: NSLayoutConstraint!
    var minimizedTopAnchorConstraint: NSLayoutConstraint!
    var bottomAnchorConstraint: NSLayoutConstraint!
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
          view.backgroundColor = .green
        
        // to make all navigation bar >>> large titles
        UINavigationBar.appearance().prefersLargeTitles = true
    
        // purple color for icons
        tabBar.tintColor = UIColor.customPurpleColor()

    /*
        // add nav bar to search controller
        let favoritesNavController = UINavigationController(rootViewController: ViewController() )
        favoritesNavController.tabBarItem.title = "Favorites"
        favoritesNavController.tabBarItem.image = #imageLiteral(resourceName: "favorites")
        
        // add nav bar to search controller
        let searchNavController = UINavigationController(rootViewController: ViewController() )
        searchNavController.tabBarItem.title = "Search"
        searchNavController.tabBarItem.image = #imageLiteral(resourceName: "search")
        
        // add nav bar to downloads controller
        let downloadsNavController = UINavigationController(rootViewController: ViewController() )
        downloadsNavController.tabBarItem.title = "Downloads"
        downloadsNavController.tabBarItem.image = #imageLiteral(resourceName: "downloads")
         
 */

       setupViewControllers()
       setupPlayerDetailsView()
       //player view animation
       //perform(#selector(maximizePlayerDetails), with: nil, afterDelay: 1) // 1 sec
    }
    
    
    
    //MARK:- PLAYER FUNCS

    // give the parameter a defautl value ... to avoid refactor all the code
    func maximizePlayerDetails(episode: Episode?, playlistEpisodes: [Episode] = [] ) {
        print("start max animation ...")
        // you have to arrange it right so no conflict happens betwwen constraint
        minimizedTopAnchorConstraint.isActive = false
        maximizedTopAnchorConstraint.isActive = true
        maximizedTopAnchorConstraint.constant = 0
        bottomAnchorConstraint.constant = 0
        if episode != nil {
            playerView.episode = episode
        }
        playerView.playlistEpisodes = playlistEpisodes
        playerView.miniPlayer.alpha = 0
        playerView.maximizedView.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded() // any time you need to animate anchors add this
            self.tabBar.isHidden = true // we want tabBar disappear by going down 100
            //self.tabBar.transform = CGAffineTransform(translationX: 0, y: 100)
        }, completion: nil)
    }
    
    
    func minmizePlayerDetails() {
        print("start min animation ...")
        // you have to arrange it right so no conflict happens betwwen constraint
        maximizedTopAnchorConstraint.isActive = false
        bottomAnchorConstraint.constant = view.frame.height
        minimizedTopAnchorConstraint.isActive = true
        playerView.miniPlayer.alpha = 1
        playerView.maximizedView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded() // any time you need to animate anchors add this
            self.tabBar.isHidden = false
            //self.tabBar.transform = .identity
        }, completion: nil)
    }
    
    
     
    //MARK:- Setup Functions
    
    fileprivate func setupPlayerDetailsView() {
    print("Setting up playerDetailsView")
    guard let playerDetailsView = playerView.view else { return }
        
    //view.addSubview(playerDetailsView)
    view.insertSubview(playerDetailsView, belowSubview: tabBar)
    playerDetailsView.translatesAutoresizingMaskIntoConstraints = false
    
    maximizedTopAnchorConstraint =
    playerDetailsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: view.frame.height)
    maximizedTopAnchorConstraint.isActive = true
        
        
    minimizedTopAnchorConstraint = playerDetailsView.topAnchor.constraint(equalTo: tabBar.topAnchor,constant: -64)
    //minimizedTopAnchorConstraint.isActive = true
    
    bottomAnchorConstraint = playerDetailsView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: view.frame.height)
    bottomAnchorConstraint.isActive = true
    
    playerDetailsView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0)
    .isActive = true
   
    playerDetailsView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
    .isActive = true

}
    
    
   fileprivate func setupViewControllers() {
    
   let layout = UICollectionViewFlowLayout() // to allow flow layout in grid
   let favoritesNavController = generateNavigationController(for: FavoritesController(collectionViewLayout: layout), title: "Favorites", image: #imageLiteral(resourceName: "favorites"))
    
   let searchNavController = generateNavigationController(for: PodcastsSearchController(), title: "Search", image: #imageLiteral(resourceName: "search"))
    
   let downloadsNavController = generateNavigationController(for: DownloadsController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))
    
   /*let downloadsNavController = generateNavigationController(for: ViewController(), title: "Downloads", image: #imageLiteral(resourceName: "downloads"))*/
   
   // Array of Controllers
   viewControllers = [searchNavController, favoritesNavController, downloadsNavController]
   }
    
    
    //MARK:- Helper Functions
    
    // very cool trick for comments >> Mark ... so you can navigate to it like any class
       //if you write after mark :- ...it will make horizontal bar
    fileprivate func generateNavigationController(for rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
           let navController = UINavigationController(rootViewController: rootViewController)
           //navController.navigationBar.prefersLargeTitles = true  // large navigationBar title
           rootViewController.navigationItem.title = title
           navController.tabBarItem.title = title
           navController.tabBarItem.image = image
        return navController
    }
    
}
