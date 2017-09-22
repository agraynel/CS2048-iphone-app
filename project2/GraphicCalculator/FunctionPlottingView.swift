//
//  FunctionPlottingView.swift
//  GraphicCalculator
//
//  Created by Agraynel on 2017/9/9.
//  Copyright © 2017年 Agraynel. All rights reserved.
//

import UIKit

protocol FunctionPlottingViewDelegate {
    func getFunctionToPlot() -> ((Double) -> Double)?
    func getCrossHairLocation() -> CGPoint?
}

class FunctionPlottingView: UIView {

    var minX : Double = -1.0, maxX : Double = 1.0, minY : Double = -1.0, maxY : Double = 1.0
    var origin : CGPoint = CGPoint(x: 0, y: 0)
    var delegate : FunctionPlottingViewDelegate?
    var newScale : CGFloat = 0.0
    var T = CGAffineTransform.identity
    
    override func draw(_ rect: CGRect) {
        
        //generate tranformation
        var xMin = -1.0
        var xMax = 1.0
        
        let delta = (xMax - xMin) / (2.0 * (Double)(rect.width))
        let oldScale = bounds.width / CGFloat(xMax - xMin)
        var scale = bounds.width / CGFloat(xMax - xMin)
        
        xMin = Double((rect.minX - rect.midX - origin.x) / scale)
        xMax = Double((rect.maxX - rect.midX - origin.x) / scale)
        
        if (newScale != 0.0) {
            scale = newScale
        }
        
        T = CGAffineTransform.identity
        T = T.translatedBy(x: rect.midX + origin.x, y: rect.midY + origin.y)
        T = T.scaledBy(x: scale, y: -scale)
        
        //generate inverse transformation
        let inverseT = T.inverted()
    
        //draw axis
        let newXmin = xMin * Double(oldScale) / (Double(scale))
        let newXmax  = xMax * Double(oldScale) / (Double(scale))
        
        var path = UIBezierPath()
        UIColor.blue.setStroke()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.midY + origin.y).applying(inverseT))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + origin.y).applying(inverseT))
        path.move(to: CGPoint(x: rect.midX + origin.x, y: rect.minY).applying(inverseT))
        path.addLine(to: CGPoint(x: rect.midX + origin.x, y: rect.maxY).applying(inverseT))
        
        path.apply(T)
        path.stroke()
        //draw function
        path = UIBezierPath()
        if let f = self.delegate?.getFunctionToPlot() {
            var p = CGPoint(x: newXmin, y: f(newXmin))
            // Apply transform to a point
            p = p.applying(inverseT)
        
            var prevPoint : CGPoint?
            
            for x in stride(from: newXmin, to: newXmax, by:delta) {
                let y = f(x)
                if (y.isNormal || y.isZero) {
                    p = CGPoint(x: x, y: f(x))
                    //p = p.applying(inverseT)
                    if prevPoint == nil {
                        path.move(to: p)
                    } else {
                        path.addLine(to: p)
                    }
                    prevPoint = p
                } else {
                    prevPoint = nil
                }
            }
            UIColor.red.setStroke()
            path.lineWidth = 2.0
            path.apply(T)
            path.stroke()
        }
        
        //draw crosshair function
        path = UIBezierPath()
        if let pnt = self.delegate?.getCrossHairLocation() {
            print(pnt)
            //path.apply(inverseT)
            
            var pntX : CGFloat = pnt.x + origin.x
            var oldY : CGFloat = pnt.y + origin.y
            var pntY : CGFloat = pnt.y + origin.y
            var derivativeY: CGFloat = pnt.y + origin.y
            if let f = delegate?.getFunctionToPlot() {
                pntX = (pnt.x - rect.midX) / scale
                pntY = CGFloat(f(Double(pntX)))
                oldY = pntY * (-scale) + rect.midY + origin.y
                derivativeY = CGFloat(f(Double(pntX + 0.1)))
            } else {
                return
            }
            
            UIColor.lightGray.setStroke()
            
            path.move(to: CGPoint(x:rect.minX, y:oldY).applying(inverseT))
            path.addLine(to: CGPoint(x:rect.maxX, y:oldY).applying(inverseT))
            path.move(to: CGPoint(x:pnt.x + origin.x, y:rect.minY).applying(inverseT))
            path.addLine(to: CGPoint(x:pnt.x + origin.x, y:rect.maxY).applying(inverseT))
            path.apply(T)
            path.stroke()
            
            path.move(to: CGPoint(x: pnt.x + origin.x, y: oldY))
            path.apply(T)
            let label = NSString(format: "(x: %.1f, y: %.1f)", pntX, pntY)
            label.draw(at: CGPoint(x: pnt.x + origin.x, y: oldY), withAttributes: nil)
            
            //draw tangent
            path = UIBezierPath()
            path.apply(T)
            let derivative = Double(derivativeY - pntY) / 0.1
            UIColor.purple.setStroke()
            let b = Double(pntY) - derivative * Double(pntX)
            var point = CGPoint(x: newXmin, y: derivative * newXmin + b)
            point = point.applying(T)
            path.move(to: point)
            for x in stride(from: newXmin, to: newXmax, by:delta) {

                point = CGPoint(x: x, y: derivative * x + b)
                point = point.applying(T)
                path.addLine(to: point)
            }
            path.stroke()
        }
    }
    

}
