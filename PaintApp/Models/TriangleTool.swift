//
//  TriangleTool.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/18/21.
//

import Foundation
import UIKit

class TriangleTool: SketchTool {
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
        let context = UIBezierPath()

        context.lineWidth = lineWidth

        if self.isFill {
            context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            context.addLine(to: CGPoint(x: firstPoint.x, y: lastPoint.y))
            context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context.close()

            lineColor.setFill()
            context.fill()
        } else {
            context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            context.addLine(to: CGPoint(x: firstPoint.x, y: lastPoint.y))
            context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context.close()
             
            lineColor.setStroke()
            context.stroke()
        }
    }
}
