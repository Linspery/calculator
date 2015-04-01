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
    
  
}


