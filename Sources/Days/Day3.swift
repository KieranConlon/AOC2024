//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

final class Day3: Day {
  var title: String = "Mull It Over"
  var dayNum: Int = 3
  let exampleData: [Int: String] = [
    1: "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))",
    2: "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  ]
  
  enum InstructionType: String {
    case mul
    
    func execute(_ operands: (Int, Int)) -> Int {
      switch self {
      case .mul: return operands.0 * operands.1
      }
    }
  }
  
  struct ComputerInstruction: CustomStringConvertible {
    var op: InstructionType
    var operands: (Int, Int)
    var value: Int {
      op.execute(operands)
    }
    
    var description: String {
      "\(op)(\(operands.0),\(operands.1))"
    }
  }
  
  struct ComputerProgram {
    var instructions: [ComputerInstruction]
    
    func run() -> Int {
      instructions.reduce(0) { $0 + $1.value }
    }
    
    func list() -> String {
      """
      \(instructions.map(\.description).joined(separator: "\n"))
      ------------
      \(instructions.count) instructions
      """
    }
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = """
      Scan the corrupted memory for uncorrupted `mul` instructions.
      What do you get if you add up all of the results of the multiplications?
      """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      var program1: ComputerProgram = parseInputPart1(input)
      
      return "\(program1.run())"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = """
      Handle the new instructions; 
      what do you get if you add up all of the results of just the enabled multiplications?
      """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[2]! : rawInput
      var program2: ComputerProgram = parseInputPart2(input)
      
      return "\(program2.run())"
    }
  }
  
  private func parseInputPart1(_ input: String) -> ComputerProgram {
    let lines: [String] = parseInput(input)
    
    let instructions = lines.flatMap { line in
      getComputerInstructions(in: line)
    }
    
    return ComputerProgram(instructions: instructions.compactMap { $0 })
  }
  
  private func parseInputPart2(_ input: String) -> ComputerProgram {
    /// Using `.joined()` here to convert `[String]` to `String`
    /// This makes sure the logic finds the correct number of `mul(_,_)` instructions
    /// Fixed Bug:  In a situation where the file was on multiple lines as follows.
    /// do()........don't().........
    /// ..mul(2,2)....do()..........
    /// ...........do().............
    /// This changed ensures that `mul(2,2)` is a disabled instruction.
    let lines = parseInput(input).joined()
    
    /// Create an array of "buggy" lines, all starting with a `do()`
    let buggyDoInstructions = lines.components(separatedBy: "do()")
    
    /// For each buggy line, search for "don't()" and remove to EOL
    let debuggedDoInstructions = buggyDoInstructions.map { line in
      if let range = line.range(of: "don't()") {
        return String(line[line.startIndex..<range.lowerBound])
      }
      return line
    }
    
    /// Parse the remaining lines to get the valid `mul(_,_)` instructions
    let instructions = debuggedDoInstructions.flatMap { line in
      getComputerInstructions(in: line)
    }
    
    return ComputerProgram(instructions: instructions.compactMap { $0 })
  }
  
  private func getComputerInstructions(in line: String) -> [ComputerInstruction] {
    let regExPattern = /(?<instruction>mul)\((?<opA>\d{1,3}),(?<opB>\d{1,3})\)/
    let regex = regExPattern.regex
    
    var instructions = [ComputerInstruction]()
    let matches = line.matches(of: regex)
    for match in matches {
      guard let opA = Int(match.output.opA),
            let opB = Int(match.output.opB),
            let instruction = InstructionType(rawValue: String(match.output.instruction)) else {
        continue
      }
      
      instructions.append(ComputerInstruction(op: instruction, operands: (opA, opB)))
    }
    
    return instructions
  }

  private func parseInput(_ input: String) -> [String] {
    let lines: [String] = rawDataAsArray(input, delim: .newline) { line in
      guard !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
      return line
    }.compactMap { $0 }
    
    return lines
  }
}
