//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation
import PerformanceTimer

struct CodeChallenge {
  var title: String
  var question: String
  var answer: String
  var executionTime: Double
  var reportingUnits: PerformanceTimerUnits
}

func executeChallenge(title: String, question: String, timerReportingUnits: PerformanceTimerUnits, answer: () -> String) -> CodeChallenge {
  var timer = PerformanceTimer(reportingUnits: timerReportingUnits)
  timer.start()
  let result = answer()
  _ = timer.stop()
  
  return CodeChallenge(title: title, question: question, answer: result, executionTime: timer.total, reportingUnits: timerReportingUnits)
}

protocol Day {
  var dayNum: Int { get }
  var exampleData: [Int: String] { get }
  
  init()
  
  func part1(_ input: String) -> CodeChallenge
  func part2(_ input: String) -> CodeChallenge
}

extension Day {
  var exampleData: String { "" }
}
