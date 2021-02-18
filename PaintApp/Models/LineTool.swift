//
//  LineTool.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/18/21.
//

import Foundation
import UIKit

class LineTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    
    init() {
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .black
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    func moveFromPoint(_ startPoint: CGPoint, endPoint: CGPoint) {
        self.lastPoint = endPoint
    }
    
    func draw() {
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        bezierPath.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        lineColor.setStroke()
        bezierPath.lineWidth = lineWidth
        bezierPath.stroke()

    }
    
}
