//
//  DrawTool.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/15/21.
//

import UIKit

protocol SketchTool {
    var lineWidth: CGFloat { get set }
    var lineColor: UIColor { get set }
    var lineAlpha: CGFloat { get set }
    
    func setInitialPoint(_ firstPoint: CGPoint)
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint)
    func draw()
}

class PenTool: UIBezierPath, SketchTool {
    var path: CGMutablePath
    var lineColor: UIColor
    var lineAlpha: CGFloat
    
    override init() {
        path = CGMutablePath.init()
        lineColor = .black
        lineAlpha = 0
        super.init()
        lineCapStyle = CGLineCap.round
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInitialPoint(_ firstPoint: CGPoint) {}
    
    func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {}
    
    func createBezierRenderingBox(_ previousPoint2: CGPoint, widhPreviousPoint previousPoint1: CGPoint, withCurrentPoint cpoint: CGPoint) -> CGRect {
        let mid1 = middlePoint(previousPoint1, previousPoint2: previousPoint2)
        let mid2 = middlePoint(cpoint, previousPoint2: previousPoint1)
        let subpath = CGMutablePath.init()
        
        subpath.move(to: CGPoint(x: mid1.x, y: mid1.y))
        subpath.addQuadCurve(to: CGPoint(x: mid2.x, y: mid2.y), control: CGPoint(x: previousPoint1.x, y: previousPoint1.y))
        path.addPath(subpath)
        
        var boundingBox: CGRect = subpath.boundingBox
        boundingBox.origin.x -= lineWidth * 2.0
        boundingBox.origin.y -= lineWidth * 2.0
        boundingBox.size.width += lineWidth * 4.0
        boundingBox.size.height += lineWidth * 4.0
        
        return boundingBox
    }
    
    private func middlePoint(_ previousPoint1: CGPoint, previousPoint2: CGPoint) -> CGPoint {
        return CGPoint(x: (previousPoint1.x + previousPoint2.x) * 0.5, y: (previousPoint1.y + previousPoint2.y) * 0.5)
    }
    
    func draw() {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        
        context.addPath(path)
        context.setLineCap(.round)
        context.setLineWidth(lineWidth)
        context.setStrokeColor(lineColor.cgColor)
        context.setBlendMode(.normal)
        context.setAlpha(lineAlpha)
        context.strokePath()
        
    }
}

class LineTool: SketchTool {
    var lineWidth: CGFloat
    var lineColor: UIColor
    var lineAlpha: CGFloat
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    
    init() {
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        self.lastPoint = endPoint
    }
    
    internal func draw() {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(lineColor.cgColor)
        context.setLineCap(.square)
        context.setLineWidth(lineWidth)
        context.setAlpha(lineAlpha)
        context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
        context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
        context.strokePath()
    }
    
    func angleWithFirstPoint(first: CGPoint, second: CGPoint) -> Float {
        let dx: CGFloat = second.x - first.x
        let dy: CGFloat = second.y - first.y
        let angle = atan2f(Float(dy), Float(dx))
        
        return angle
    }
    
    func pointWithAngle(angle: CGFloat, distance: CGFloat) -> CGPoint {
        let x = Float(distance) * cosf(Float(angle))
        let y = Float(distance) * sinf(Float(angle))
        
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}

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
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
        isFill = false
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        self.lastPoint = endPoint
    }
    
    internal func draw() {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let rectToFill = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - self.firstPoint.x, height: lastPoint.y - firstPoint.y)
        
        context.setAlpha(lineAlpha)
        
        if self.isFill {
            context.setFillColor(lineColor.cgColor)
            UIGraphicsGetCurrentContext()!.fill(rectToFill)
        } else {
            context.setStrokeColor(lineColor.cgColor)
            context.setLineWidth(lineWidth)
            UIGraphicsGetCurrentContext()!.stroke(rectToFill)
        }
    }
}

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
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
        isFill = false
    }

    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }

    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        self.lastPoint = endPoint
    }

    internal func draw() {
        let context = UIBezierPath()

        context.lineWidth = lineWidth

        if self.isFill {
            context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context.addLine(to: CGPoint(x: (lastPoint.x + firstPoint.x)/2, y: (lastPoint.y - firstPoint.y)/2))
            context.addLine(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            context.close()

            lineColor.setFill()
            context.fill()
        } else {
            context.move(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            context.addLine(to: CGPoint(x: lastPoint.x, y: lastPoint.y))
            context.addLine(to: CGPoint(x: (lastPoint.x + firstPoint.x)/2, y: (lastPoint.y - firstPoint.y)/2))
            context.addLine(to: CGPoint(x: firstPoint.x, y: firstPoint.y))
            context.close()
             
            lineColor.setStroke()
            context.stroke()
        }
    }
}

class EllipseTool: SketchTool {
    var eraserWidth: CGFloat
    var lineWidth: CGFloat
    var lineAlpha: CGFloat
    var lineColor: UIColor
    var firstPoint: CGPoint
    var lastPoint: CGPoint
    var isFill: Bool
    
    init() {
        eraserWidth = 0
        lineWidth = 1.0
        lineAlpha = 1.0
        lineColor = .blue
        firstPoint = CGPoint(x: 0, y: 0)
        lastPoint = CGPoint(x: 0, y: 0)
        isFill = false
    }
    
    internal func setInitialPoint(_ firstPoint: CGPoint) {
        self.firstPoint = firstPoint
    }
    
    internal func moveFromPoint(_ startPoint: CGPoint, toPoint endPoint: CGPoint) {
        lastPoint = endPoint
    }
    
    internal func draw() {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setAlpha(lineAlpha)
        context.setLineWidth(lineWidth)
        
        let rectToFill = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - self.firstPoint.x, height: lastPoint.y - firstPoint.y)
        
        if self.isFill {
            context.setFillColor(lineColor.cgColor)
            UIGraphicsGetCurrentContext()!.fillEllipse(in: rectToFill)
        } else {
            context.setStrokeColor(lineColor.cgColor)
            UIGraphicsGetCurrentContext()!.strokeEllipse(in: rectToFill)
        }
    }
}


