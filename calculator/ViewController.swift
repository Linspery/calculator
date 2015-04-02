//
//  ViewController.swift
//  calculator
//
//  Created by Linspery on 15/3/26.
//  Copyright (c) 2015年 Linspery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsUseIt:Bool = false
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsUseIt{
            display.text = display.text!+digit
        }else{
            display.text = digit
            userIsUseIt = true
        }
        
    }
    
    var operandStack = Array<Double>()
    

    @IBAction func enter() {
        userIsUseIt = false
        operandStack.append(displayValue)
        println("\(operandStack)")
    }
    @IBAction func operate(sender: UIButton) {
        let operation = sender.currentTitle!
        if userIsUseIt {
            enter()
        }
        switch operation{
        case "×":performOperation{$0*$1}
        case "÷":performOperation{$1/$0}
        case "+":performOperation{$0+$1}
        case "−":performOperation{$1-$0}
        case "√":performOperation{sqrt($0)}
        default: break
        }
    }
    
    
    func performOperation(operation:(Double,Double)->Double){
        if operandStack.count>=2{
            displayValue = operation(operandStack.removeLast(),operandStack.removeLast())
            enter()
        }
    }
    func performOperation(operation:Double->Double){
        if operandStack.count>=2{
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }

    var displayValue:Double{
        get{
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set{
            display.text = "\(newValue)"
            userIsUseIt = false
            
        }
    }
  
}


