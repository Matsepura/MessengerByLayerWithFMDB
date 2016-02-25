//
//  TimeMessageLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 25.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class TimeMessageLayer: CATextLayer {
    
    var textLayer = CATextLayer()
    
    func setupTextLayer() {
        
//        self.frame.size = CGSize(width: 50, height: 50)
        let string = "13:03"
        self.string = string
        

        self.textLayer.string?.attributedText 
        self.anchorPoint = CGPoint(x: 1, y: 1)
        
        self.font = UIFont.systemFontSize()
        self.foregroundColor = UIColor.redColor().CGColor
        // wtf?!
        self.wrapped = true
        
        
//        self.layer.masksToBounds = true
//        self.layer.anchorPoint = CGPoint(x: 0, y: 0)
//        guard let image = UIImage(named: "userpic-big") else { return }
//        self.setImageForAvatar(image)
//        self.addTarget(self, action: "avatarButtonPressed:", forControlEvents: .TouchUpInside)
//        self.frame.size = CGSize(width: 30, height: 30)
    }
    
//    func setAttributedTime(time: String) -> NSAttributedString {
//        let string = "14:17"
//        
//        let attributedString = NSMutableAttributedString(string: string ?? "00:00" , attributes: [
//            NSFontAttributeName : UIFont.systemFontOfSize(16),
//            NSForegroundColorAttributeName : UIColor.whiteColor()
//            ])
//        
//        return attributedString
//    }

}
