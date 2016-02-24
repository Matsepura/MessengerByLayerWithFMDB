//
//  NHTextLayer.swift
//  MessengerByLayerWithFMDB
//
//  Created by Semen Matsepura on 17.02.16.
//  Copyright © 2016 Semen Matsepura. All rights reserved.
//

// создаем кастомный класс для текста, так как в родном классе есть баг с отображением эмоджиков

import UIKit

class NHTextLayer: CALayer {
    
    // MARK: - Property
    
    var attributedText: NSAttributedString?
    
    // MARK: -  Setup
    
    override func layoutSublayers() {
        super.layoutSublayers()
        self.setNeedsDisplay()
    }
    
    override func drawInContext(ctx: CGContext) {
        autoreleasepool {
            super.drawInContext(ctx)
            
            guard let attributedText = self.attributedText else { return }
            let bounds = self.bounds
            CGContextSetTextMatrix(ctx, CGAffineTransformIdentity)
            CGContextTranslateCTM(ctx, bounds.minX, bounds.maxY)
            CGContextScaleCTM(ctx, 1, -1)
            
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, bounds)
            let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
            let frame = CTFramesetterCreateFrame(framesetter, CFRange(location: 0, length: 0), path, nil)
            CTFrameDraw(frame, ctx)
        }
    }
}