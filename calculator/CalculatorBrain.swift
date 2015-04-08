//
//  CalculatorBrain.swift
//  calculator
//
//  Created by Linspery on 15/4/3.
//  Copyright (c) 2015年 Linspery. All rights reserved.
//

import Foundation

class CalculatorBrain {
    private enum Op:Printable{
        case Operand(Double)
        case UnaryOperand(String,Double -> Double)
        case BinaryOperand(String, (Double,Double) ->Double)
        
        var description: String{
            get{
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .UnaryOperand(let symbol, _):
                    return symbol
                case .BinaryOperand(let symbol,_):
                    return symbol
                }
            }
        }
        
    }
    
    private var opStack = [Op]()
    private var knownOps = [String:Op]()
    
    init(){
        
        func learnOp(op:Op){
            knownOps[op.description]=op
        }
        learnOp(Op.BinaryOperand("×", *))
        learnOp(Op.BinaryOperand("÷"){$1/$0})
        learnOp(Op.BinaryOperand("+", +))
        learnOp(Op.BinaryOperand("−"){$1-$0})
        learnOp(Op.UnaryOperand("√", sqrt))
    
//        knownOps["×"] = Op.BinaryOperand("×", *)
//        knownOps["÷"] = Op.BinaryOperand("÷"){$1/$0}
//        knownOps["+"] = Op.BinaryOperand("+", +)
//        knownOps["−"] = Op.BinaryOperand("−"){$1-$0}
//        knownOps["√"] = Op.UnaryOperand("√", sqrt)
    }
    var program:AnyObject{//guaranteed to be a PropretyList
        get{
            return opStack.map{$0.description}
        }
        set{
            if let opSymbols = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newOpStack.append(op)
                    }else if let operand = NSNumberFormatter().numberFromString(opSymbol)?.doubleValue{
                        
                        newOpStack.append(.Operand(operand))
                    }
                    opStack = newOpStack
                }
            }
            
        }
    }

    private func evaluate(ops:[Op]) -> (result : Double? , remainingOps:[Op]){
        if !ops.isEmpty{
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand , remainingOps)
            case .UnaryOperand(_, let operation):
                let operandEvaluate = evaluate(remainingOps)
                if let operand = operandEvaluate.result{
                    return (operation(operand),operandEvaluate.remainingOps)
                }
            case .BinaryOperand(_, let operation):
                let op1Evaluate = evaluate(remainingOps)
                if let operand1 = op1Evaluate.result {
                    let op2Evaluate = evaluate(op1Evaluate.remainingOps)
                    if let operand2 = op2Evaluate.result {
                        return (operation(operand1,operand2),op2Evaluate.remainingOps)
                    }
                }
            }
        }
        return (nil,ops)
    }
    
    func evaluate() -> Double?{
        let (result,remainder) = evaluate(opStack)
        println("\(opStack) = \(result) with \(remainder) left over")
        return result
    }
    
    func pushOperand(oprenad:Double) ->Double?{
        opStack.append(Op.Operand(oprenad))
        return evaluate()
    }
    func performOperation(symbol:String)-> Double?{
        if let operation = knownOps[symbol]{
            opStack.append(operation)
        }
        return evaluate()
    }
    
}
