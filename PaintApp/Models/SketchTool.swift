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
    func moveFromPoint(_ startPoint: CGPoint, endPoint: CGPoint)
    func draw()
}



