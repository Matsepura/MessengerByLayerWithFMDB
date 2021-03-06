//
//  GroupIncomingImageCell.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 24.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class GroupIncomingImageCell: IncomingImageCell, AvatarButtonProtocol {

    var avatarButton = UIButton(type: .Custom)
    
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
        self.avatarButtonSetup()
    }
    
    func avatarButtonSetup() {
        self.setupButton(avatarButton)
        avatarButton.addTarget(self, action: "avatarButtonPressed:", forControlEvents: .TouchUpInside)

        self.contentView.addSubview(avatarButton)
    }
    
    override func layoutSubviews() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        self.avatarButton.center = CGPoint(x: 5, y: self.messageLayer.bounds.height - 26)
        super.layoutSubviews()
        self.messageLayer.position = CGPoint(x: 35, y: self.bounds.height / 2)
        
        CATransaction.commit()
    }
    
    func avatarButtonPressed(sender: UIButton) {
        print("avatarButtonPressed")
    }

}