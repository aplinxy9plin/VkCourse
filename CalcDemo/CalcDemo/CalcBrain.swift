//
//  CalcBrain.swift
//  CalcDemo
//
//  Created by Michael Galperin on 29.09.16.
//
// no. it remindes nothing!

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Double, power: Double) -> Double {
    return pow(radix, power)
}

class CalcBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "√" : Operation.UnaryOperation(sqrt),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "±" : Operation.UnaryOperation({ $0 != 0 ? -$0 : 0 }),
        "x²": Operation.UnaryOperation({ $0 ^^ 2}),
        "sin": Operation.UnaryOperation(sin),
        "cos": Operation.UnaryOperation(cos),
        "tg": Operation.UnaryOperation(tan),
        "%": Operation.UnaryOperation({$0 / 100}),
        "=": Operation.Equals
    ]
    
    enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let c):
                    accumulator = c
                case .UnaryOperation(let unaryFunc):
                    accumulator = unaryFunc(accumulator)
                case .BinaryOperation(let binaryFunc):
                    executePending()
                    pending = PendingBinaryInfo(binaryFunction: binaryFunc, firstOperand: accumulator)
                case .Equals:
                    executePending()
            }
        }
    }
    
    private func executePending(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryInfo?
    struct PendingBinaryInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
        
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
    //really nothing to remind ¯\_(ツ)_/¯
}
