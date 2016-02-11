//
//  MessageLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

typealias MessageLayer = BaseMessageLayer<CALayer>

class BaseMessageLayer<T: CALayer>: CALayer {
    
    // MARK: - Property
    
    var contentInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    private(set) var contentLayer: T!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        
        self.commonInit()
    }
    
    required override init() {
        super.init()
        
        self.commonInit()
    }
    
    private func commonInit() {
        self.contentLayer = T.init()
        self.addSublayer(self.contentLayer)
        
        self.backgroundColor = UIColor.clearColor().CGColor
        self.masksToBounds = false
        
        self.drawsAsynchronously = true
        
        self.contentLayer.opaque = true
        
        self.contentLayer.drawsAsynchronously = true
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        let frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets)
        
        self.contentLayer.frame = frame
    }
}
