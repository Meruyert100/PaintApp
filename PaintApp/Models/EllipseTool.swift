//
//  EllipseTool.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/18/21.
//

import Foundation
import UIKit

class EllipseTool: SketchTool {
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
        lastPoint = endPoint
    }
    
    func draw() {
        let circlePath = UIBezierPath(ovalIn: CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - self.firstPoint.x, height: lastPoint.y - firstPoint.y))
        
        circlePath.lineWidth = lineWidth

        if self.isFill {
            lineColor.setFill()
            circlePath.fill()
        } else {
            lineColor.setStroke()
            circlePath.stroke()
        }
    }
}
