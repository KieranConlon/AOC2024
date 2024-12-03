//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

// This is just a general template to use for each daiy challenge
final class DayX: Day {
  var title: String = "Daily Challenge Title"
  var dayNum: Int = 99
  let exampleData: [Int: String] = [
    1: "",
    2: ""
  ]
  
  // Create one or more structs to use for the challenge
  struct ModelForChallenge {
    var someData: [Any]
  }

  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "Question for part 1."
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let _: ModelForChallenge = parseInput(input)

      // Do something with the data
      let result: Int = 999
      
      
      return "\(result)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "Question for part 2."
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      let _: ModelForChallenge = parseInput(input)

      // Do something with the data
      let result: Int = 999
      
      
      return "\(result)"
    }
  }
  
  // Read the input data and populate the required struct(s)
  // Most of the time the input data for AoC can be held in an array
  // so the `rawDataAsArray` function under Utilities is useful.
  private func parseInput(_ input: String) -> ModelForChallenge {
    // Read the input and return a ModelForChallenge
    return ModelForChallenge(someData: [])
  }
}
