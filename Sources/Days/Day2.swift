//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

final class Day2: Day {
  var title: String = "Red-Nosed Reports"
  var dayNum: Int = 2
  let exampleData: [Int: String] = [
    1: """
    7 6 4 2 1
    1 2 7 8 9
    9 7 6 2 1
    1 3 2 4 5
    8 6 4 4 1
    1 3 6 7 9
    """
  ]
  
  struct ReactorReport {
    var levels: [Int]
    let safeStep = 1...3
    
    var isSafe: Bool {
      isSafe()
    }
    
    var isSafeWithDampener: Bool {
      isSafe(usingDampener: true)
    }
    
    private func isSafe(usingDampener: Bool = false) -> Bool {
      // a single-level list is always safe - not sure if the data will have any of these
      guard levels.count > 1 else { return true }
      
      var markedSafe = safetyCheck(for: levels)
      if !usingDampener || markedSafe { return markedSafe }
      
      // if marked not safe, perform the dampener check
      let count = levels.count
      for i in 0..<count {
        var modifiedLevels = levels
        modifiedLevels.remove(at: i)
        if safetyCheck(for: modifiedLevels) {
          markedSafe = true
          break
        }
      }
      
      return markedSafe
    }
    
    private func safetyCheck(for levels: [Int]) -> Bool {
      let step = levels[1] - levels[0]
      // determine the "direction of travel"
      let isAscending = step > 0
      
      for i in 1..<levels.count {
        let step = levels[i] - levels[i-1]
        // if the step change out of bounds, bail with false
        if !safeStep.contains(abs(step)) { return false }
        
        // if the next step is in the wrong direction, bail with false
        if (isAscending && step < 0) || (!isAscending && step > 0) { return false }
      }
      return true
    }
  }
  
  struct ReactorData {
    var reports = [ReactorReport]()
    var safeReportCount: Int {
      reports.reduce(0) { partialResult, report in
        partialResult + (report.isSafe ? 1 : 0) }
    }
    
    var safeDamperReportCount: Int {
      reports.reduce(0) { partialResult, report in
        partialResult + (report.isSafeWithDampener ? 1 : 0) }
    }
  }
  
  var reactorData = ReactorData()
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "Analyze the unusual data from the engineers. How many reports are safe?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      reactorData = parseInput(input)
      
      return "\(reactorData.safeReportCount)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    //let useExampleData: Bool = true
    let question = "Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      return "\(reactorData.safeDamperReportCount)"
    }
  }
  
  private func parseInput(_ input: String) -> ReactorData {
    let reports: [ReactorReport] = rawDataAsArray(input, delim: .newline) { line in
      guard !line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return nil }
      return ReactorReport(levels: rawDataAsArray(line, delim: .space) { Int($0) })
    }.compactMap { $0 } // dicard any nil entries
    
    return ReactorData(reports: reports)
  }
}
