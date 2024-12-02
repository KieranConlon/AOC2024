//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation
import ArgumentParser

@main
struct AOC2024: AsyncParsableCommand {
  
  @Argument(help: "AOC Day Number")
  var dayNumber: Int
  
  @Option(name: [.short, .long],
          help: "Folder containing the AOC input files.")
  var inputFolder: String = "./inputData/"
  
  mutating func run() async throws {
    // Dynamically load the required Day class from the application bundle
    guard let dayClass = Bundle.main.classNamed("aoc2024.Day\(dayNumber)") as? Day.Type else {
      print("Error: Class for Day \(dayNumber) not found - Exiting.")
      return
    }
    let day = dayClass.init()
    
    let inputData = readDataFromFile(inputFolder: inputFolder, day: dayNumber)
    
    var ans = day.part1(inputData)
    printChallenge(ans, day: day, part: 1)
    
    ans = day.part2(inputData)
    printChallenge(ans, day: day, part: 2)
  }
  
  private func printChallenge(_ challenge: CodeChallenge, day: Day, part: Int) {
    print("\n--- Day \(day.dayNum): \(challenge.title) - Challenge \(part) ---")
    print(challenge.question)
//    if let exampleData = day.exampleData[part] {
//      print("Example Data:")
//      print(exampleData)
//    }
    print()
    print("Answer: \(challenge.answer)")
    print("  Took: \(challenge.executionTime) \(challenge.reportingUnits.label)")
  }
}
