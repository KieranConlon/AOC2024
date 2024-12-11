//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

// This is just a general template to use for each daiy challenge
final class Day11: Day {
  var title: String = "Plutonian Pebbles"
  var dayNum: Int = 11
  let exampleData: [Int: String] = [
    1: "125 17",
    2: ""
  ]
  
  private func numDigits(_ num: Int64) -> Int {
    Int(floor(log10(abs(Double(num))) + 1))
  }
  
  private func split(_ num: Int64, atDigit: Int) -> [Int64] {
    let rem = num % Int64(pow(10, Double(atDigit)))
    let div = num / Int64(pow(10, Double(atDigit)))
    return [div, rem]
  }
  
  
  var blinkCache: [Int64: [Int64]] = [:]
  
  func doBlink(stone: Int64) -> [Int64] {
    // Rule-1: If stone's value is 0 -> 1
    if stone == 0 {
      return [1]
    }
    
    if let cachedResult = blinkCache[stone] {
      return cachedResult
    }
    
    // Rule-2: If stone's value has even number of digits, split the value into two stones
    let numDigits = numDigits(stone)
    if numDigits % 2 == 0 {
      let result = split(stone, atDigit: numDigits / 2)
      blinkCache[stone] = result
      return result
    }
    
    // Rule-3: If other don't apply multiply by 2024
    let result = [stone * 2024]
    blinkCache[stone] = result
    return result
  }
  
  var countCache: [String: Int64] = [:]
  
  func countStones(_ stones: [Int64], blinks: Int) -> Int64 {
    if blinks == 0 {
      return Int64(stones.count)
    }
    
    let key = "\(stones)-\(blinks)"
    if let cachedResult = countCache[key] {
      return cachedResult
    }
    
    var stoneCount: Int64 = 0
    for stone in stones {
      let blinkResults = doBlink(stone: stone)
      
      stoneCount += countStones(blinkResults, blinks: blinks - 1)
    }
    
    countCache[key] = stoneCount
    
    return stoneCount
  }
  
  func part1(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "How many stones will you have after blinking 25 times?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      
      let stones = parseInput(input)
      let stoneCount = countStones(stones, blinks: 25)
      
      return "\(stoneCount)"
    }
  }
  
  func part2(_ rawInput: String) -> CodeChallenge {
    let useExampleData: Bool = false
    let question = "How many stones would you have after blinking a total of 75 times?"
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      
      let stones = parseInput(input)
      let stoneCount = countStones(stones, blinks: 75)
      
      return "\(stoneCount)"
    }
  }
  
  private func parseInput(_ input: String) -> [Int64] {
    return input.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: " ").map { Int64($0) }.compactMap { $0 }
  }
}

