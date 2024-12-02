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
      // a single-level list is always safe - not sure if the data will have any of these
      guard levels.count > 1 else { return true }
      
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
  }
  
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "Analyze the unusual data from the engineers. How many reports are safe?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let reactorData = parseInput(input)
      
      return "\(reactorData.safeReportCount)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = true
    let question = "tbc"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      //      let input = useExampleData ? exampleData[1]! : rawInput
      //      let locationList: LocationList = parseInput(input)
      //
      //      let list2Counts = locationList.list2.reduce(into: [:]) { value, count in
      //        value[count, default: 0] += 1
      //      }
      //
      //      let similarityScore = locationList.list1.map { value in
      //        value * (list2Counts[value] ?? 0)
      //      }.reduce(0, +)
      //
      //      return "\(similarityScore)"
      return ""
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
