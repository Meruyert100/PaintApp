//
//  DrawView.swift
//  PaintApp
//
//  Created by Meruyert Tastandiyeva on 2/14/21.
//

import UIKit

public enum SketchToolType {
    case pen
    case line
    case rectangleStroke
    case rectangleFill
    case ellipseStroke
    case ellipseFill
    case triangleStroke
    case triangleFill
}

@objc public protocol SketchViewDelegate: NSObjectProtocol  {
    @objc optional func drawView(_ view: SketchView, willBeginDrawUsingTool tool: AnyObject)
    @objc optional func drawView(_ view: SketchView, didEndDrawUsingTool tool: AnyObject)
}

public class SketchView: UIView {
    public var lineColor = UIColor.clear
    public var lineWidth = CGFloat(10)
    public var lineAlpha = CGFloat(1)
    public var drawTool: SketchToolType = .pen
    public var sketchViewDelegate: SketchViewDelegate?
    private var currentTool: SketchTool?
    private let pathArray: NSMutableArray = NSMutableArray()
    private let bufferArray: NSMutableArray = NSMutableArray()
    private var currentPoint: CGPoint?
    private var previousPoint1: CGPoint?
    private var previousPoint2: CGPoint?
    private var image: UIImage?
    private var backgroundImage: UIImage?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForInitial()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        prepareForInitial()
    }
    
    private func prepareForInitial() {
        backgroundColor = UIColor.clear
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        image?.draw(at: CGPoint.zero)
        
        currentTool?.draw()
    }
    
    private func updateCacheImage(_ isUpdate: Bool) {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        
        if isUpdate {
            image = nil
            
            if let backgroundImage = backgroundImage  {
                (backgroundImage.copy() as! UIImage).draw(at: CGPoint.zero)
            }
            
            for obj in pathArray {
                if let tool = obj as? SketchTool {
                    tool.draw()
                }
            }
        } else {
            image?.draw(at: .zero)
            currentTool?.draw()
        }
        
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    private func toolWithCurrentSettings() -> SketchTool? {
        switch drawTool {
        case .pen:
            return PenTool()
        case .line:
            return LineTool()
        case .rectangleStroke:
            let rectTool = RectTool()
            rectTool.isFill = false
            return rectTool
        case .rectangleFill:
            let rectTool = RectTool()
            rectTool.isFill = true
            return rectTool
        case .ellipseStroke:
            let ellipseTool = EllipseTool()
            ellipseTool.isFill = false
            return ellipseTool
        case .ellipseFill:
            let ellipseTool = EllipseTool()
            ellipseTool.isFill = true
            return ellipseTool
        case .triangleStroke:
            let triangleTool = TriangleTool()
            triangleTool.isFill = false
            return triangleTool
        case .triangleFill:
            let triangleTool = TriangleTool()
            triangleTool.isFill = true
            return triangleTool
        }
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        currentTool = toolWithCurrentSettings()
        currentTool?.lineWidth = lineWidth
        currentTool?.lineColor = lineColor
        currentTool?.lineAlpha = lineAlpha
        
        guard let currentTool = currentTool else { return }
        pathArray.add(currentTool)
        currentTool.setInitialPoint(currentPoint!)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        previousPoint2 = previousPoint1
        previousPoint1 = touch.previousLocation(in: self)
        currentPoint = touch.location(in: self)
        
        if let penTool = currentTool as? PenTool {
            let renderingBox = penTool.createBezierRenderingBox(previousPoint2!, widhPreviousPoint: previousPoint1!, withCurrentPoint: currentPoint!)
            
            setNeedsDisplay(renderingBox)
        } else {
            currentTool?.moveFromPoint(previousPoint1!, toPoint: currentPoint!)
            setNeedsDisplay()
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesMoved(touches, with: event)
        finishDrawing()
    }
    
    fileprivate func finishDrawing() {
        updateCacheImage(false)
        bufferArray.removeAllObjects()
        sketchViewDelegate?.drawView?(self, didEndDrawUsingTool: currentTool! as AnyObject)
        currentTool = nil
    }
    
    private func resetTool() {
        currentTool = nil
    }
    
    public func clear() {
        resetTool()
        bufferArray.removeAllObjects()
        pathArray.removeAllObjects()
        updateCacheImage(true)
        
        setNeedsDisplay()
    }
        
    public func undo() {
        if canUndo() {
            guard let tool = pathArray.lastObject as? SketchTool else { return }
            resetTool()
            bufferArray.add(tool)
            pathArray.removeLastObject()
            updateCacheImage(true)
            
            setNeedsDisplay()
        }
    }
    
    public func redo() {
        if canRedo() {
            guard let tool = bufferArray.lastObject as? SketchTool else { return }
            resetTool()
            pathArray.add(tool)
            bufferArray.removeLastObject()
            updateCacheImage(true)

            setNeedsDisplay()
        }
    }
    
    func canUndo() -> Bool {
        return pathArray.count > 0
    }
    
    func canRedo() -> Bool {
        return bufferArray.count > 0
    }
}
