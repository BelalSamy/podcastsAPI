//
//  FavoritesController.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/17/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import UIKit

class FavoritesController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView.reloadData()
         
        UIApplication.mainTabBarController()?.viewControllers?[1].tabBarItem.badgeValue = nil

    }
    
    //MARK:- Setup Funcs
    
    fileprivate func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: cellId)
        
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(gesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer ) {
        print("Captured Long Press")
        let location = gesture.location(in: collectionView)
        guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { return }
        print(selectedIndexPath )
        let selectedPodcast = self.podcasts[selectedIndexPath.item]
        print(selectedPodcast)
        
        let alertController = UIAlertController(title: "Remove Podcast", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (_) in
            
            // where we remove the podcast object from collection view ------------------------------------
            self.podcasts.remove(at: selectedIndexPath.item) // remove the actual object from the array
            self.collectionView.deleteItems(at: [selectedIndexPath]) // then remove it from collection view
            
            // also remove your favorited podcast from UserDefaults
            UserDefaults.standard.deletePodcast(podcast: selectedPodcast)
            self.collectionView.reloadData()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel ))
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK:- CollectionView Funcs
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoriteCell
        let podcast = podcasts[indexPath.item]
        cell.podcast = podcast
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodesController = EpisodesController()
        episodesController.podcast = self.podcasts[indexPath.item]
        navigationController?.pushViewController(episodesController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ( view.frame.width - 3 * 16 ) / 2
        let height = width + 25 + 25 // for podcast name + artist name
        return CGSize(width: width, height: height)
    }
    
    // vertical spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // horizontal spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}
