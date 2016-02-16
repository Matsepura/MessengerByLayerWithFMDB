//
//  MessageLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

//typealias MessageLayer = BaseMessageLayer<CALayer>
//
//class BaseMessageLayer<T: CALayer>: CALayer {

class MessageLayer: CALayer {

    // MARK: - Property
    
    var contentInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    
//    private(set) var contentLayer: T!
    
     private(set) var contentLayer: CALayer!
    
    // MARK: - Setup
    
        class func contentLayerClass() -> CALayer.Type {
            return CALayer.self
        }
    
    
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
//        self.contentLayer = T.init()
        self.contentLayer = CALayer()
        self.addSublayer(self.contentLayer)
        
        self.backgroundColor = UIColor.clearColor().CGColor
        self.masksToBounds = false
        
        self.drawsAsynchronously = true
        
        self.contentLayer.opaque = true
        
        self.contentLayer.drawsAsynchronously = true
    }
    
    override func layoutSublayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        super.layoutSublayers()
//        self.contentLayer.frame = self.bounds
        let frame = UIEdgeInsetsInsetRect(self.bounds, self.contentInsets)
        
        self.contentLayer.frame = frame
        
        CATransaction.commit()
    }
}
