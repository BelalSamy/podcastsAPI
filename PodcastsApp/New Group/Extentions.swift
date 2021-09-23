//
//  Extentions.swift
//  PodcastsApp
//
//  Created by Belal Samy on 11/4/19.
//  Copyright © 2019 Belal Samy. All rights reserved.
//

import Foundation
import UIKit
import AVKit

extension UIApplication {
    static func mainTabBarController() -> MainTabBarController? {
        let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first

        return keyWindow?.rootViewController as? MainTabBarController
    }
}

extension UIColor {
    static func customPurpleColor() -> UIColor {
        return UIColor(red:0.62, green:0.27, blue:0.92, alpha:1.0)
    }
}


// anchor extension
extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat,
                width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height ).isActive = true
        }
    }
}

// html to label
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

// http to https
extension String {
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}


extension CMTime {
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--:-- "
        }
        
        //let secondsInDouble = CMTimeGetSeconds(self)
        /*guard !(secondsInDouble.isNaN || secondsInDouble.isInfinite) else {
            return "illegal value" // or do some error handling
        }*/
        
        let totalSeconds = Int(CMTimeGetSeconds(self))
  
        // if it 65 sec .. it shoud be 1 minute and 5 seconds .. so now we get the second value
        let seconds = totalSeconds // to get the seconds
        let minutes = totalSeconds / 60
        let hours = minutes / 60
        // 2 digit integars always have leading value
        let timeFormatString = String(format: "%02d:%02d:%02d", hours, minutes % 60, seconds % 60)
        return timeFormatString
    }
}


