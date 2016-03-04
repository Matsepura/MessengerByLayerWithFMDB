//
//  DeliveredCheckProtocol.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 29.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

protocol DeliveredCheckProtocol {
    
    func setupDeliveredCheck(deliveredCheck: CALayer)
    
}

extension DeliveredCheckProtocol {
    
    func setupDeliveredCheck(deliveredCheck: CALayer) {
    
        deliveredCheck.frame.size = CGSize(width: 12, height: 9)
        let image = UIImage(named: "icon-dialog-read")?.CGImage
        deliveredCheck.contentsGravity = kCAGravityResizeAspectFill
        deliveredCheck.contents = image
        deliveredCheck.contentsScale = UIScreen.mainScreen().scale
        
    }
    
}
