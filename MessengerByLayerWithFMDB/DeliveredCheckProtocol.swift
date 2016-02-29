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
        
        let image = UIImage(named: "icon-dialog-read-blue")?.CGImage
        deliveredCheck.contentsGravity = kCAGravityResizeAspectFill
        //        self.deliveredCheck.masksToBounds = true
        //        deliveredCheck.contents = UIImage(named: "icon-dialog-read-blue")?.CGImage
        deliveredCheck.contents = image
        deliveredCheck.contentsScale = UIScreen.mainScreen().scale
        
    }
    
}
