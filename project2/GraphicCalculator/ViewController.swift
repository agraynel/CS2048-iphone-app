//
//  ViewController.swift
//  GraphicCalculator
//
//  Created by Agraynel on 2017/9/9.
//  Copyright © 2017年 Agraynel. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController, UITextFieldDelegate, FunctionPlottingViewDelegate {

    @IBOutlet weak var exprTextField: UITextField!
    
    @IBOutlet weak var plotView: FunctionPlottingView!
    
    var crosshairLoc : CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exprTextField.delegate = self
        plotView.delegate = self
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("called return")
        exprTextField.resignFirstResponder() //dismiss keyboard
        plotView.setNeedsDisplay()//need redraw
        return false
    }
    
    func getFunctionToPlot() -> ((Double) -> Double)? {
        let expr = exprTextField.text
        if expr == "" {
            return nil
        }
        
        //print (expr)
        let jsSrc = "sin = Math.sin; cos = Math.cos; tan = Math.tan; log = Math.log; var f = function(x) {return \( expr! ); }"
        let jsCtx = JSContext()!
        jsCtx.evaluateScript(jsSrc);
        
        //get a reference to the function in the context
        guard let f = jsCtx.objectForKeyedSubscript("f") else {
            return nil
        }
        
        //if input garbage we cant evaluate
        if f.isUndefined {
            return nil
        }
        
        return {(x: Double) in return f.call(withArguments: [x])!.toDouble() }
    }
    
    func getCrossHairLocation() -> CGPoint? {
        return crosshairLoc
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        crosshairLoc = sender.location(in: plotView)
        plotView.setNeedsDisplay()
    }

    @IBAction func press(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.ended {
            crosshairLoc = nil
        }
        plotView.setNeedsDisplay()
    }
    
    @IBAction func pan(_ sender: UIPanGestureRecognizer) {
        plotView.origin = sender.translation(in: plotView)
        plotView.setNeedsDisplay()
    }
    
    @IBAction func pinch(_ sender: UIPinchGestureRecognizer) {
        plotView.newScale = sender.scale;
        plotView.setNeedsDisplay()
    }
}

