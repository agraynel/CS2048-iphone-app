//
//  ViewController.swift
//  GraphingCalculator
//
//  Created by Daniel Hauagge on 9/9/17.
//  Copyright © 2017 CS2048 Instructor. All rights reserved.
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
        exprTextField.resignFirstResponder() // <- dismisses the keyboard
        plotView.setNeedsDisplay() // <- tells the plot view it needs to redraw
        return false
    }
    
    func getFunctionToPlot() -> ((Double) -> Double)? {
        let expr = exprTextField.text
        if expr == "" {
            return nil
        }
        
        // JavaScript code we will execute
        let jsSrc = "sin = Math.sin; cos = Math.cos; var f = function(x) { return \( expr! ); }"

        // Create code and execute script, this will create the function
        // inside the context
        let jsCtx = JSContext()!
        jsCtx.evaluateScript(jsSrc)
        
        // Get a reference to the function in the context
        guard let f = jsCtx.objectForKeyedSubscript("f") else {
            return nil
        }
        // If the user input garbage and we can't evaluate, then exit
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
}

