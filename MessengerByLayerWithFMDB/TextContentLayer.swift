//
//  TextContentLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 11.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

import UIKit

class TextContentLayer: CALayer {
    
    // MARK: - Property
    
    private(set) var textLayer: NHTextLayer!
    
    var textInsets: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Setup
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.commonInit()
    }
    
    override init(layer: AnyObject) {
        super.init(layer: layer)
        self.commonInit()
    }
    
    override init() {
        super.init()
        self.commonInit()
    }
    
    private func commonInit() {
        self.textLayer = NHTextLayer()
        self.textLayer.contentsScale = UIScreen.mainScreen().scale
        self.addSublayer(self.textLayer)
        
        self.textLayer.actions = ["contents": NSNull()]
        self.textLayer.drawsAsynchronously = true
    }
    
    override func layoutSublayers() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        super.layoutSublayers()
        self.textLayer.frame = UIEdgeInsetsInsetRect(self.bounds, self.textInsets)
        
        CATransaction.commit()
    }
}

