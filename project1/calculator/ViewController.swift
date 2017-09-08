//
//  ViewController.swift
//  calculator
//
//  Created by Agraynel on 2017/8/26.
//  Copyright © 2017年 Agraynel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var numberOnScreen: Double = 0;
    var hiddenNumber: Double = 0;
    var previousNumber: Double = 0;
    var isPartialResult = false;
    var operation = 0;
    var canAddDecimal = true;
    var initBorderWidth = 0;
    

    @IBAction func numberButtonWasPressed(_ sender: UIButton) {
        if isPartialResult == true {
            resultsLabel.text = sender.titleLabel?.text!
            isPartialResult = false;
        } else {
            if resultsLabel.text == "0" {
                resultsLabel.text = sender.titleLabel?.text!
            } else {
                resultsLabel.text = resultsLabel.text! + sender.titleLabel!.text!
            }
        }
        hiddenNumber = Double(resultsLabel.text!)!
        numberOnScreen = hiddenNumber
    }
    
    func clearBorderWidth() {
        if operation >= 11 && operation <= 14 {
            if let button = self.view.viewWithTag(operation) as? UIButton {
                button.layer.borderWidth = 0;
            }
        }
    }
    
    @IBAction func operation(_ sender: UIButton) {
        clearBorderWidth();
        if (!(resultsLabel.text == "+" || resultsLabel.text == "-" || resultsLabel.text == "*" || resultsLabel.text == "/")) {
            equalTo();
            previousNumber = Double(resultsLabel.text!)!
        }
        switch(sender.tag) {
            case 11:
                resultsLabel.text = "+";
                break;
            case 12:
                resultsLabel.text = "-";
                break;
            case 13:
                resultsLabel.text = "*";
                break;
            case 14:
                resultsLabel.text = "/";
                break;
            default:
                break;
        }
        sender.layer.borderWidth = 2.0;
        operation = sender.tag
        isPartialResult = true;
    }
    
    func equalTo() {
        switch(operation) {
        case 11:
            previousNumber += hiddenNumber;
            break;
        case 12:
            previousNumber -= hiddenNumber;
            break;
        case 13:
            previousNumber *= hiddenNumber;
            break;
        case 14:
            if numberOnScreen == 0 {
                previousNumber = 0;
            } else {
                previousNumber /= hiddenNumber;
            }
            break;
        default:
            hiddenNumber = numberOnScreen;
            previousNumber = hiddenNumber;
            break;
        }
        
        if Double(previousNumber) == Double(Int(previousNumber)) {
            resultsLabel.text = String(Int(previousNumber));
        } else {
            resultsLabel.text = String(previousNumber);
        }
        numberOnScreen = previousNumber;
    }
    
    @IBAction func equal(_ sender: UIButton) {
        equalTo();
    }
    
    @IBAction func addDecimalPoint(_ sender: UIButton) {
        if canAddDecimal {
            if Double(previousNumber) == Double(Int(previousNumber)) {
                resultsLabel.text = resultsLabel.text! + sender.titleLabel!.text!
            }
        }
        canAddDecimal = false;
    }
    
    @IBAction func inversion(_ sender: UIButton) {
        numberOnScreen = -numberOnScreen;
        if Double(numberOnScreen) == Double(Int(numberOnScreen)) {
            resultsLabel.text = String(Int(numberOnScreen));
        } else {
            resultsLabel.text = String(numberOnScreen);
        }
    }
    
    @IBAction func getPercent(_ sender: UIButton) {
        numberOnScreen /= 100;
        if Double(numberOnScreen) == Double(Int(numberOnScreen)) {
            resultsLabel.text = String(Int(numberOnScreen));
        } else {
            resultsLabel.text = String(numberOnScreen);
        }
    }
    
    @IBAction func clearLabel(_ sender: UIButton) {
        clearBorderWidth();
        resultsLabel.text = "0"
        previousNumber = 0;
        numberOnScreen = 0;
        isPartialResult = false;
        operation = 0;
        canAddDecimal = true;
    }
    
    @IBOutlet weak var resultsLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        clearBorderWidth();
        resultsLabel.text = "0"
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

