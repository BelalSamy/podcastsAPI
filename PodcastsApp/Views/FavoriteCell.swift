//
//  FavoritePodcastCell.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/17/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    var podcast: Podcast! {
           didSet {
              trackNameLabel.text = podcast.trackName
              artistNameLabel.text = podcast.artistName
              guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
              podcastImageView.sd_setImage(with: url, completed: nil)
           }
       }
       
       let podcastImageView: UIImageView = {
        let iv = UIImageView()
           iv.image = #imageLiteral(resourceName: "appicon")
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
        return iv
       }()
                
       let trackNameLabel:  UILabel = {
           let lbl = UILabel()
           lbl.text = "Podcast Name"
           lbl.textColor = .black
           lbl.backgroundColor = .white
           lbl.numberOfLines = 0
           lbl.font = UIFont.boldSystemFont(ofSize: 17)
        return lbl
       }()
       
       let artistNameLabel:  UILabel = {
           let lbl = UILabel()
           lbl.text = "Artist Name"
           lbl.textColor = .lightGray
           lbl.backgroundColor = .white
           lbl.font = UIFont.systemFont(ofSize: 16)
        return lbl
       }()
       
    
    //MARK:- INIT
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    //MARK:- Setup Funcs
    
    fileprivate func setupViews() {
        backgroundColor = UIColor(white: 0, alpha: 0.1)
        
        translatesAutoresizingMaskIntoConstraints = false
        podcastImageView.heightAnchor.constraint(equalTo: podcastImageView.widthAnchor).isActive = true
        podcastImageView.layer.borderWidth = 0.5
        podcastImageView.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
        
        let stackView = UIStackView(arrangedSubviews: [podcastImageView, trackNameLabel, artistNameLabel ])
        stackView.axis = .vertical
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                         width: 0, height: 0)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
