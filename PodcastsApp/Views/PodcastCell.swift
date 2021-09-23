//
//  PodcastCell.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/5/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    var podcast: Podcast! {
        // to trigger some action to ocurr when it have a value
        didSet {
           trackNameLabel.text = podcast.trackName
           artistNameLabel.text = podcast.artistName
           episodeCountLabel.text = "\(podcast.trackCount ?? 0) Episodes" // string inerpolation
           print("\(podcast.artworkUrl600 ?? "")")
            
           guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }

            /*
                URLSession.shared.dataTask(with: url) { (data, _, _) in
                    
                    guard let imageData = data else { return }
                    //print("Finish downloading image data : ", data ?? "")
                    DispatchQueue.main.async {
                    self.podcastImageView.image = UIImage(data: imageData)
                    }
           }.resume()
            */
                        
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    let podcastImageView: UIImageView = {
     let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.contentMode = .scaleAspectFill
     return iv
    }()
             
    let trackNameLabel:  UILabel = {
        let lbl = UILabel()
        lbl.text = "Track Name"
        lbl.textColor = .black
        //lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
     return lbl
    }()
    
    let artistNameLabel:  UILabel = {
        let lbl = UILabel()
        lbl.text = "Artist Name"
        lbl.textColor = .black
        //lbl.numberOfLines = 0
        lbl.font = UIFont.systemFont(ofSize: 16)
     return lbl
    }()
    
    let episodeCountLabel:  UILabel = {
        let lbl = UILabel()
        lbl.text = "Episode Count"
        lbl.textColor = .darkGray
        lbl.font = UIFont.systemFont(ofSize: 14)
     return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        
        setupViews()
    
       }

    
    //MARK:- SETUP FUNCS
    
    fileprivate func setupViews() {

        // podcast image
        addSubview(podcastImageView)
        podcastImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil,
                                paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                                width: 100, height: 100)
        
        // stackView for labels
        let stackView = UIStackView(arrangedSubviews: [trackNameLabel, artistNameLabel, episodeCountLabel])
        stackView.axis = .vertical
        //stackView.spacing = 2.0
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: podcastImageView.rightAnchor, bottom: nil, right: rightAnchor,
                         paddingTop: 20, paddingLeft: 8, paddingBottom: 0, paddingRight: 8,
                         width: 0, height: 75)
        
        // seperator
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        addSubview(separatorView)
        separatorView.anchor(top: nil, left: stackView.leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                             paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8,
                             width: 0, height: 0.5)
        
    }

    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
 
