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
func factorial(_ k: Double) -> Double {//think it might be removed
    if k > 103 {
        return 0
    }
    return k <= 1 ? 1 : factorial(k - 1) * k
}

class CalcBrain {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double){
        accumulator = operand
    }
    
    func nullify(){
        accumulator = 0
        pending = nil
    }
    
    private enum Operation {
        case Constant(Double)
        case Unary((Double) -> Double)
        case Binary((Double, Double) -> Double)
        case Equals
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI),
        "e": Operation.Constant(M_E),
        "√" : Operation.Unary(sqrt),
        "×" : Operation.Binary({$0 * $1}),
        "÷" : Operation.Binary({$0 / $1}),
        "−" : Operation.Binary({$0 - $1}),
        "+" : Operation.Binary({$0 + $1}),
        "±" : Operation.Unary({ $0 != 0 ? -$0 : 0 }),
        "x²": Operation.Unary({ $0 ^^ 2}),
        "x³": Operation.Unary({ $0 ^^ 3 }),
        "x!": Operation.Unary(factorial),
        "sin": Operation.Unary(sin),
        "cos": Operation.Unary(cos),
        "tg": Operation.Unary(tan),
        "sec": Operation.Unary({ 1 / cos($0) }),
        "cosec": Operation.Unary({ 1 / sin($0) }),
        "ctg" : Operation.Unary({ 1 / tan($0) }),
        "log₂": Operation.Unary({ log2($0) }),
        "log₁₀": Operation.Unary({ log10($0) }),
        "ln": Operation.Unary({ log($0) / log(M_E) }),
        "Round": Operation.Unary({ round($0) }),
        "eˣ": Operation.Unary({ M_E ^^ $0 }),
        "%": Operation.Unary({$0 / 100}),
        "=": Operation.Equals
    ]
    
    func performOperation(symbol: String){
        if let operation = operations[symbol] {
            switch operation {
                case .Constant(let c):
                    accumulator = c
                case .Unary(let unaryFunc):
                    accumulator = unaryFunc(accumulator)
                case .Binary(let binaryFunc):
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
    private struct PendingBinaryInfo {
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
