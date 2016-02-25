//
//  AvatarButton.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 25.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

protocol AvatarButtonProtocol {

    func setupButton(avatarButton: UIButton)
}

extension AvatarButtonProtocol {
    
    func setupButton(avatarButton: UIButton) {
        avatarButton.layer.masksToBounds = true
        avatarButton.layer.anchorPoint = CGPoint(x: 0, y: 0)
        guard let image = UIImage(named: "userpic-big") else { return }

        avatarButton.setImage(image, forState: .Normal)
        //// нэ работает addTarget(!self!)
//        avatarButton.addTarget(self, action: "avatarButtonPressed:", forControlEvents: .TouchUpInside)
        avatarButton.frame.size = CGSize(width: 30, height: 30)
    }
    
    func setImageForAvatar(image: UIImage) -> UIImage{
        return image
    }

//    func avatarButtonPressed(sender: UIButton) {
//        print("avatarButtonPressed")
//    }
    
}