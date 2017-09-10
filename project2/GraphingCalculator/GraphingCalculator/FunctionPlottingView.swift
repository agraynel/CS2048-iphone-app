//
//  FunctionPlottingView.swift
//  GraphingCalculator
//
//  Created by Daniel Hauagge on 9/9/17.
//  Copyright © 2017 CS2048 Instructor. All rights reserved.
//

import UIKit

protocol FunctionPlottingViewDelegate {
    func getFunctionToPlot() -> ((Double) -> Double)?
    func getCrossHairLocation() -> CGPoint?
}

class FunctionPlottingView: UIView {
    
    var delegate : FunctionPlottingViewDelegate?

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Draw axis
        var path = UIBezierPath()
        UIColor.blue.setStroke()
        path.move(to: CGPoint(x:rect.minX, y:rect.midY))
        path.addLine(to: CGPoint(x:rect.maxX, y:rect.midY))
        path.move(to: CGPoint(x:rect.midX, y:rect.minY))
        path.addLine(to: CGPoint(x:rect.midX, y:rect.maxY))
        path.stroke()
        
        // Draw function
        path = UIBezierPath()
        // let f = {(x: Double) -> Double in x * x }
        if let f = self.delegate?.getFunctionToPlot() {
            let xMin = -1.0
            let xMax =  1.0
            let delta = (xMax - xMin) / (2.0 * Double(rect.width))
            
            let scale = bounds.width / CGFloat(xMax - xMin)
            var p = CGPoint(x: xMin, y: f(xMin))
            
            p.x *=  scale
            p.y *= -scale
            p.x += rect.midX
            p.y += rect.midY
            
            path.move(to: p)
            for x in stride(from: xMin, to: xMax, by: delta) {
                p = CGPoint(x: x, y: f(x))
                
                p.x *=  scale
                p.y *= -scale
                p.x += rect.midX
                p.y += rect.midY
                
                path.addLine(to: p)
            }
            UIColor.red.setStroke()
            path.lineWidth = 2.0
            path.stroke()
        }
        
        // Draw function
        path = UIBezierPath()
        if let pnt = self.delegate?.getCrossHairLocation() {
            path = UIBezierPath()
            UIColor.lightGray.setStroke()
            path.move(to: CGPoint(x:rect.minX, y:pnt.y))
            path.addLine(to: CGPoint(x:rect.maxX, y:pnt.y))
            path.move(to: CGPoint(x:pnt.x, y:rect.minY))
            path.addLine(to: CGPoint(x:pnt.x, y:rect.maxY))
            path.stroke()
        }
    }
}
