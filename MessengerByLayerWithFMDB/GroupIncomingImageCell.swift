//
//  GroupIncomingImageCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 24.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class GroupIncomingImageCell: IncomingImageCell {

    var userPicLayer = CALayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.commonInit()
    }
    
    private func commonInit() {
        setup()
    }
    
    func setup() {
        self.userPicLayerSetup()
    }
    
    func userPicLayerSetup() {
        self.userPicLayer.contentsScale = UIScreen.mainScreen().scale
        self.userPicLayer.masksToBounds = true
        self.userPicLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        if let userAvatar = UIImage(named: "userpic-big") {
            self.userPicLayer.contents = userAvatar.CGImage
        }
        
        self.contentView.layer.addSublayer(userPicLayer)
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.userPicLayer.frame.size = CGSize(width: 30, height: 30)
        self.userPicLayer.cornerRadius = 15
        self.userPicLayer.position = CGPoint(x: 5, y: self.messageLayer.bounds.height - 26)
        super.layoutSubviews()
        self.messageLayer.position = CGPoint(x: 35, y: self.bounds.height / 2)
        
        CATransaction.commit()
    }
}