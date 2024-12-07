//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

final class Day7: Day {
  var title: String = "Bridge Repair"
  var dayNum: Int = 7
  let exampleData: [Int: String] = [
    1: """
    190: 10 19
    3267: 81 40 27
    83: 17 5
    156: 15 6
    7290: 6 8 6 15
    161011: 16 10 13
    192: 17 8 14
    21037: 9 7 18 13
    292: 11 6 16 20
    
    """,
    2: ""
  ]
  
  enum Operator: String, CaseIterable {
    case add
    case multiply
    case concatenate
    
    func perform(_ operands: [Operand]) -> Int64 {
      switch self {
      case .add: return operands.reduce(0) { $0 + $1.intValue }
      case .multiply: return operands.reduce(1) { $0 * $1.intValue }
      case .concatenate:
        return Int64(operands.map { $0.stringValue }.joined() ) ?? 0
      }
    }
  }
  
  struct Operand {
    let intValue: Int64
    let stringValue: String
    
    init(_ value: Int64) {
      self.intValue = value
      self.stringValue = String(value)
    }
  }
  
  struct CalibrationEquation: CustomStringConvertible {
    var operands: [Operand]
    let requiredAnswer: Int64
    
    func possibleAnswers(using allowedOperators: [Operator]) -> [Int64] {
      guard operands.count > 1 else { return operands.map { $0.intValue } }
      
      var calculatedAnswers: [Int64] = []
      let permutations = getPermutations(operands.count - 1, using: allowedOperators)
      
      for ops in permutations {
        var result = operands[0]
        for (index, op) in ops.enumerated() {
          result = Operand(op.perform([result, operands[index + 1]]))
        }
        calculatedAnswers.append(result.intValue)
      }
      
      return calculatedAnswers
    }
    
    private func getPermutations(_ count: Int, using allowedOperators: [Operator]) -> [[Operator]] {
      guard count > 0 else { return [[]] }
      let partialPermutations = getPermutations(count - 1, using: allowedOperators)
      return partialPermutations.flatMap { perm in
        allowedOperators.map { perm + [$0] }
      }
    }
    
    var correctAnswer: Bool {
      possibleAnswers(using: Operator.allCases).contains(requiredAnswer)
    }
    
    var description: String {
      "\(correctAnswer ? "*" : " ") \(requiredAnswer): \(operands) -> \(possibleAnswers(using: Operator.allCases))"
    }

    func correctAnswer(using allowedOperators: [Operator]) -> Bool {
        let possible = possibleAnswers(using: allowedOperators)
        return possible.contains(requiredAnswer)
    }
  }
  
  
  struct CalibrationData {
    var equations: [CalibrationEquation]
    
    func getCalibrationResult(using allowedOperators: [Operator]) -> Int64 {
      equations.compactMap { equation in
          equation.correctAnswer(using: allowedOperators) ? equation.requiredAnswer : nil
        }.reduce(0, +)
    }
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = true
    let question = """
        Determine which equations could possibly be true. 
        What is their total calibration result?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .seconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let calibrationData = parseInput(input)
      let operators: [Operator] = [.add, .multiply]
      let result = calibrationData.getCalibrationResult(using: operators)
      
      return "\(result)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = true
    let question = """
        Using your new knowledge of elephant hiding spots, determine which equations could possibly be true. 
        What is their total calibration result?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .seconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let calibrationData = parseInput(input)
      let operators: [Operator] = [.add, .multiply, .concatenate]
      let result = calibrationData.getCalibrationResult(using: operators)
      
      return "\(result)"
    }
  }
  
  private func parseInput(_ input: String) -> CalibrationData {
    let equations: [CalibrationEquation] = rawDataAsArray(input, delim: .newline) { line in
      let calibStrings: [String] = rawDataAsArray(line, delim: .colon) { $0 }.compactMap { $0 }
      guard let requiredAnswer: Int64 = Int64(calibStrings[0].trimmingCharacters(in: .whitespaces)) else { return nil }
      
      let operands: [Operand] = rawDataAsArray(calibStrings[1], delim: .space) {
        Int64($0.trimmingCharacters(in: .whitespaces))
      }
        .compactMap { $0 }
        .map { Operand($0) }
      
      return CalibrationEquation(operands: operands, requiredAnswer: requiredAnswer)
    }.compactMap { $0 }
    
    return CalibrationData(equations: equations)
  }
}
