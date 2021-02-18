//
//  RectTool.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/18/21.
//

import Foundation
import UIKit

class RectTool: SketchTool {
    var lineWidth: CGFloat
    var lineAlpha: CGFloat
    var lineColor: UIColor
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    var isFill: Bool
    
    init() {
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .black
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
        isFill = false
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    func moveFromPoint(_ startPoint: CGPoint, endPoint: CGPoint) {
        self.lastPoint = endPoint
    }
    
    func draw() {
        let rectanglePath = UIBezierPath(rect: CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - firstPoint.x, height: lastPoint.y - firstPoint.y))

        rectanglePath.lineWidth = lineWidth
        
        if self.isFill {
            lineColor.setFill()
            rectanglePath.fill()
        } else {
            lineColor.setStroke()
            rectanglePath.stroke()
        }
        
    }
}
