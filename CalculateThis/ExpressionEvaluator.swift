//
//  ExpressionEvaluator.swift
//  CalculateThis
//
//  Safe expression evaluator for custom calculator formulas
//

import Foundation

class ExpressionEvaluator {
    private var variables: [String: Double] = [:]

    func setVariable(_ name: String, value: Double) {
        variables[name] = value
    }

    func evaluate(_ expression: String) throws -> Double {
        let cleanExpression = expression.replacingOccurrences(of: " ", with: "")
        let tokens = try tokenize(cleanExpression)
        return try evaluateTokens(tokens)
    }

    // MARK: - Tokenization

    private enum Token {
        case number(Double)
        case variable(String)
        case function(String)
        case operator_(String)
        case leftParen
        case rightParen
        case comma
    }

    private func tokenize(_ expression: String) throws -> [Token] {
        var tokens: [Token] = []
        var i = expression.startIndex

        while i < expression.endIndex {
            let char = expression[i]

            if char.isNumber || char == "." {
                var numStr = String(char)
                i = expression.index(after: i)
                while i < expression.endIndex && (expression[i].isNumber || expression[i] == ".") {
                    numStr.append(expression[i])
                    i = expression.index(after: i)
                }
                if let num = Double(numStr) {
                    tokens.append(.number(num))
                }
                continue
            }

            if char.isLetter {
                var name = String(char)
                i = expression.index(after: i)
                while i < expression.endIndex && (expression[i].isLetter || expression[i].isNumber || expression[i] == "_") {
                    name.append(expression[i])
                    i = expression.index(after: i)
                }

                // Check if it's a function (followed by parenthesis)
                if i < expression.endIndex && expression[i] == "(" {
                    tokens.append(.function(name))
                } else {
                    tokens.append(.variable(name))
                }
                continue
            }

            switch char {
            case "+", "-", "*", "/", "^":
                tokens.append(.operator_(String(char)))
            case "(":
                tokens.append(.leftParen)
            case ")":
                tokens.append(.rightParen)
            case ",":
                tokens.append(.comma)
            default:
                break
            }

            i = expression.index(after: i)
        }

        return tokens
    }

    // MARK: - Evaluation

    private func evaluateTokens(_ tokens: [Token]) throws -> Double {
        var output: [Double] = []
        var operators: [Token] = []
        var i = 0

        func precedence(_ op: String) -> Int {
            switch op {
            case "+", "-": return 1
            case "*", "/": return 2
            case "^": return 3
            default: return 0
            }
        }

        func applyOperator(_ op: String, _ b: Double, _ a: Double) throws -> Double {
            switch op {
            case "+": return a + b
            case "-": return a - b
            case "*": return a * b
            case "/":
                guard b != 0 else { throw EvaluationError.divisionByZero }
                return a / b
            case "^": return pow(a, b)
            default: throw EvaluationError.invalidOperator(op)
            }
        }

        func processOperator() throws {
            guard let token = operators.popLast() else { return }
            switch token {
            case .operator_(let op):
                guard output.count >= 2 else { throw EvaluationError.invalidExpression }
                let b = output.removeLast()
                let a = output.removeLast()
                output.append(try applyOperator(op, b, a))
            case .function(let name):
                let result = try applyFunction(name, &output)
                output.append(result)
            default:
                break
            }
        }

        while i < tokens.count {
            let token = tokens[i]

            switch token {
            case .number(let num):
                output.append(num)

            case .variable(let name):
                guard let value = variables[name] else {
                    throw EvaluationError.unknownVariable(name)
                }
                output.append(value)

            case .function(let name):
                operators.append(.function(name))

            case .operator_(let op):
                while let last = operators.last,
                      case .operator_(let lastOp) = last,
                      precedence(lastOp) >= precedence(op) {
                    try processOperator()
                }
                operators.append(.operator_(op))

            case .leftParen:
                operators.append(.leftParen)

            case .rightParen:
                while let last = operators.last, case .leftParen = last {
                    break
                }
                while let last = operators.last {
                    if case .leftParen = last {
                        operators.removeLast()
                        break
                    }
                    try processOperator()
                }

                // Check if there's a function before the parenthesis
                if let last = operators.last, case .function = last {
                    try processOperator()
                }

            case .comma:
                while let last = operators.last {
                    if case .leftParen = last {
                        break
                    }
                    try processOperator()
                }
            }

            i += 1
        }

        while !operators.isEmpty {
            try processOperator()
        }

        guard output.count == 1 else {
            throw EvaluationError.invalidExpression
        }

        return output[0]
    }

    // MARK: - Functions

    private func applyFunction(_ name: String, _ stack: inout [Double]) throws -> Double {
        switch name.lowercased() {
        case "sqrt":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return sqrt(arg)

        case "abs":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return abs(arg)

        case "sin":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return sin(arg)

        case "cos":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return cos(arg)

        case "tan":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return tan(arg)

        case "log":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return log10(arg)

        case "ln":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return log(arg)

        case "exp":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return exp(arg)

        case "pow":
            guard stack.count >= 2 else { throw EvaluationError.invalidFunctionCall }
            let exponent = stack.removeLast()
            let base = stack.removeLast()
            return pow(base, exponent)

        case "min":
            guard stack.count >= 2 else { throw EvaluationError.invalidFunctionCall }
            let b = stack.removeLast()
            let a = stack.removeLast()
            return min(a, b)

        case "max":
            guard stack.count >= 2 else { throw EvaluationError.invalidFunctionCall }
            let b = stack.removeLast()
            let a = stack.removeLast()
            return max(a, b)

        case "round":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return round(arg)

        case "floor":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return floor(arg)

        case "ceil":
            guard !stack.isEmpty else { throw EvaluationError.invalidFunctionCall }
            let arg = stack.removeLast()
            return ceil(arg)

        default:
            throw EvaluationError.unknownFunction(name)
        }
    }

    // MARK: - Errors

    enum EvaluationError: Error, LocalizedError {
        case invalidExpression
        case divisionByZero
        case unknownVariable(String)
        case unknownFunction(String)
        case invalidOperator(String)
        case invalidFunctionCall

        var errorDescription: String? {
            switch self {
            case .invalidExpression:
                return "Invalid expression"
            case .divisionByZero:
                return "Division by zero"
            case .unknownVariable(let name):
                return "Unknown variable: \(name)"
            case .unknownFunction(let name):
                return "Unknown function: \(name)"
            case .invalidOperator(let op):
                return "Invalid operator: \(op)"
            case .invalidFunctionCall:
                return "Invalid function call"
            }
        }
    }
}
