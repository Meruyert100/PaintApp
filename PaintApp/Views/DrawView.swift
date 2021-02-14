//
//  DrawView.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/14/21.
//

import UIKit

class DrawView: UIView {

    fileprivate var lines = [Line]()
    fileprivate var circles = [Circle]()
    fileprivate var rectangles = [Rectangle]()
    fileprivate var triangles = [Triangle]()
    
    fileprivate var strokeColor = UIColor.clear
    fileprivate var strokeWidth: CGFloat = 0
    
    var penIsSelected = false
    var circleIsSelected = false
    var lineIsSelected = false
    var rectIsSelected = false
    var triangleIsSelected = false
    
    var fillIsSelected = false
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        if penIsSelected {
            for pointLine in lines{
                context.setStrokeColor(pointLine.strokeColor.cgColor)
                context.setLineWidth(pointLine.strokeWidth)
                for (index, point) in pointLine.lines.enumerated(){
                    if index == 0{
                        context.move(to: point)
                    }else{
                        context.addLine(to: point)
                    }
                }
                context.strokePath()
            }
        }
        
        if lineIsSelected {
            for pointLine in lines{
                context.setStrokeColor(pointLine.strokeColor.cgColor)
                context.setLineWidth(pointLine.strokeWidth)
                for (index, point) in pointLine.lines.enumerated(){
                    if index == 0{
                        context.move(to: point)
                    } else {
                        context.addLine(to: CGPoint(x: point.x + point.x, y: point.y + point.y))
                        context.strokePath()

                    }
                }
                
            }
        }
        
        if circleIsSelected {
            for circle in circles{
                context.setStrokeColor(circle.strokeColor.cgColor)
                context.setLineWidth(circle.strokeWidth)
                for (index, point) in circle.circles.enumerated(){
                    
                }
                context.strokePath()
            }
        }
        
        if rectIsSelected {
            
        }
        
        if triangleIsSelected {
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if penIsSelected || lineIsSelected {
            let line = Line.init(strokeWidth: self.strokeWidth, strokeColor: self.strokeColor, lines: [CGPoint]())
            lines.append(line)
        }
        
        if circleIsSelected {
            let circle = Circle.init(strokeWidth: self.strokeWidth, strokeColor: self.strokeColor, circles: [CGPoint]())
            circles.append(circle)
        }

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else { return }
        
        if penIsSelected || lineIsSelected {
            guard var lastLine = lines.popLast() else { return }
            lastLine.lines.append(point)
            lines.append(lastLine)
        }
        
        if circleIsSelected {
            guard var lastCircle = circles.popLast() else { return }
            lastCircle.circles.append(point)
            circles.append(lastCircle)
        }
        
        
        
        self.setNeedsDisplay()
    }
    
    func setStrokeWidth(_ width: CGFloat){
        self.strokeWidth = width
    }
    
    func setStrokeColor(_ color: UIColor){
        self.strokeColor = color
    }
    
    func undoAction(){
        if penIsSelected || lineIsSelected {
            if !lines.isEmpty {
                lines.removeLast()
            }
        }
        self.setNeedsDisplay()
    }
    
    func clearAction(){
        if penIsSelected || lineIsSelected {
            if !lines.isEmpty {
                lines.removeAll()
            }
        }
        self.setNeedsDisplay()
    }

}
