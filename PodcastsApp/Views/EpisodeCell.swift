//
//  EpisodeCell.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/6/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {
    
    var episode: Episode? {
        didSet {
            // title
            titleLabel.text = episode?.title
            
            // date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM, yyyy"
            
            guard let date = episode?.pubDate else { return }
            dateLabel.text = dateFormatter.string(from: date)
            
            // describtion
            let description = episode?.describtion
            //describtionLabel.attributedText = description?.htmlToAttributedString
            describtionLabel.text = description
            
            // image
            guard let url = URL(string: episode?.imageUrl?.toSecureHTTPS() ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    let episodeImageView: UIImageView = {
     let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "appicon")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
     return iv
    }()
    
    let progressLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "100%"
        lbl.textAlignment = .center
        lbl.textColor = .white
        lbl.shadowColor = .black
        lbl.shadowOffset.height = 1 // to make the shadow at the bottom
        lbl.isHidden = true
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        return lbl
    }()
    
    let dateLabel:  UILabel = {
           let lbl = UILabel()
           lbl.text = "episode date"
           lbl.textColor = UIColor.customPurpleColor()
           lbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return lbl
       }()
    
    let titleLabel:  UILabel = {
        let lbl = UILabel()
        lbl.text = "episode Name"
        lbl.textColor = .black
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
     return lbl
    }()
    
    let describtionLabel:  UILabel = {
        let lbl = UILabel()
        lbl.text = "episode description"
        lbl.textColor = .lightGray
        lbl.numberOfLines = 0
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
     return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //backgroundColor = .green
        setupViews()
    }
    
    //MARK:- SETUP FUNCS
       
       fileprivate func setupViews() {

           // podcast image
           addSubview(episodeImageView)
           episodeImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil,
                                   paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 0,
                                   width: 100, height: 100)
        
           addSubview(progressLabel)
           progressLabel.anchor(top: episodeImageView.topAnchor, left: episodeImageView.leftAnchor, bottom:                   episodeImageView.bottomAnchor, right: episodeImageView.rightAnchor,
                                paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0,
                                width: 0, height: 0)

           // stackView for labels
           let stackView = UIStackView(arrangedSubviews: [dateLabel, titleLabel, describtionLabel ])
        
           stackView.axis = .vertical
           stackView.spacing = 2.0
           //stackView.distribution = .fillEqually
           addSubview(stackView)
           stackView.anchor(top: topAnchor, left: episodeImageView.rightAnchor, bottom: nil,
                                   right: rightAnchor,
                                   paddingTop: 16, paddingLeft: 8, paddingBottom: 0, paddingRight: 8,
                                   width: 0, height: 120)
           
           // seperator
           let separatorView = UIView()
           separatorView.backgroundColor = UIColor(white: 0, alpha: 0.5)
           addSubview(separatorView)
           separatorView.anchor(top: nil, left: titleLabel.leftAnchor, bottom: bottomAnchor,
                                right: rightAnchor,
                                paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8,
                                width: 0, height: 0.5)
           
       }
    
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
