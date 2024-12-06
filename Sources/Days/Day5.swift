//
//  firecrestHORIZON.uk
//  🦋 @kieran.firecresthorizon.uk
//

import Foundation

final class Day5: Day {
  var title: String = "Print Queue"
  var dayNum: Int = 5
  let exampleData: [Int: String] = [
    1: """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13
    
    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """,
    2: ""
  ]
  
  typealias Page = Int
  
  struct PageRule: Equatable, Comparable, CustomStringConvertible {
    static func < (lhs: Day5.PageRule, rhs: Day5.PageRule) -> Bool {
      lhs.page < rhs.page
    }
    
    var page: Page
    var followingPages: [Page]
    
    var description: String {
      "Page \(page), following pages: \(followingPages.sorted())"
    }
  }
  
  struct PageUpdate: CustomStringConvertible {
    var pages: [Page]
    var isValid: Bool = true
    
    /// Find the middle page
    var middlePage: Page? {
      guard !pages.isEmpty else { return nil }  // Handle empty array case
      let middleIndex = pages.count / 2         // Integer division for middle index
      return pages[middleIndex]
    }
    
    var description: String {
      "\(isValid ? "✅" : "❌") \(pages)"
    }
  }
  
  struct PageOrderRules {
    var rules: [PageRule]
    var updates: [PageUpdate]
    
    private func isValidSequence(_ pages: [Page]) -> Bool {
      for i in 0..<pages.count - 1 {
        let currentPage = pages[i]
        let nextPage = pages[i + 1]
        
        // Find the rule for the current page
        guard let rule = rules.first(where: { $0.page == currentPage }) else {
          return false // No rule found
        }
        
        // Check if the next page is allowed by the current page's rule
        if !rule.followingPages.contains(nextPage) {
          return false
        }
      }
      return true
    }
    
    mutating func checkValidity() {
      for (i, update) in updates.enumerated() {
        updates[i].isValid = isValidSequence(update.pages)
      }
    }
    
    func sumValidMiddlePages() -> Int {
      updates.reduce(0) { sum, update in
        if update.isValid {
          return sum + (update.middlePage ?? 0)
        }
        return sum
      }
    }
    
    mutating func fixInvalidUpdates() {
      for (i, update) in updates.enumerated() {
        if update.isValid { continue }
        
        var sortedUpdate = update
        sortedUpdate.pages.sort { lhs, rhs in
          canFollow(lhs: lhs, rhs: rhs, rule: rules)
        }
        
        // Update the validity of the page update
        sortedUpdate.isValid = isValidSequence(sortedUpdate.pages)
        updates[i] = sortedUpdate
      }
    }

    private func canFollow(lhs: Page, rhs: Page, rule: [PageRule]) -> Bool {
      guard let rule = rules.first(where: { $0.page == lhs }) else { return false }
      return rule.followingPages.contains(rhs)
    }
  }
  
  let useExampleData: Bool = true
  var pageOrderRules = PageOrderRules(rules: [], updates: [])
  var part1Result: Int = 0
  
  /*
   *  ---+++*** Part 1 ***+++---
   */
  func part1(_ rawInput: String) -> CodeChallenge {
    let question = """
        Determine which updates are already in the correct order. 
        What do you get if you add up the middle page number from those correctly-ordered updates?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      let input = useExampleData ? exampleData[1]! : rawInput
      pageOrderRules = parseInput(input)
      pageOrderRules.checkValidity()
      part1Result = pageOrderRules.sumValidMiddlePages()
      
      print("The Rules:")
      for rule in pageOrderRules.rules.sorted() {
        print(rule)
      }
      
      print("The Updates:")
      for update in pageOrderRules.updates {
        print(update)
      }
      
      return "\(part1Result)"
    }
  }
  
  /*
   *  ---+++*** Part 2 ***+++---
   */
  func part2(_ rawInput: String) -> CodeChallenge {
    let question = """
        Find the updates which are not in the correct order. 
        What do you get if you add up the middle page numbers after correctly ordering just those updates?
        """
    
    return executeChallenge(title: title, question: question, timerReportingUnits: .milliseconds) {
      
      pageOrderRules.fixInvalidUpdates()
      let part2Result = pageOrderRules.sumValidMiddlePages()
      
      print("The Updates:")
      for update in pageOrderRules.updates {
        print(update)
      }
      let result = part2Result - part1Result
      
      return "\(result)"
    }
  }
  
  private func parseInput(_ input: String) -> PageOrderRules {
    let rulesAndPages: [String] = rawDataAsArray(input, delim: .dblNewline) { line in
      line.trimmingCharacters(in: .whitespacesAndNewlines)
    }.compactMap { $0 } // remove nils
    
    guard rulesAndPages.count == 2 else {
      fatalError("Input format invalid")
    }
    
    // Handle the rules first
    let rawRules = rulesAndPages[0]
    let rules: [PageRule] = rawDataAsArray(rawRules, delim: .newline) { line in
      let parts: [Page] = rawDataAsArray(line, delim: .pipe) { Page($0) }.compactMap { $0 }
      
      return PageRule(page: parts[0], followingPages: [parts[1]])
    }.compactMap { $0 }
    
    // This is a complicated constructor - I did get ChatGPT to help me clean-up my previous VERY messy version!
    let combinedRules: [PageRule] = Dictionary(grouping: rules, by: { $0.page })
      .map { key, value in
        PageRule(page: key, followingPages: value.flatMap { $0.followingPages })
      }
    
    // Now handle the pages list
    let rawUpdates = rulesAndPages[1]
    let updates: [PageUpdate] = rawDataAsArray(rawUpdates, delim: .newline) { line in
      PageUpdate(pages: rawDataAsArray(line, delim: .comma) { page in
        Page(page)
      }.compactMap { $0 })
    }.compactMap { $0 }
    
    return PageOrderRules(rules: combinedRules, updates: updates)
  }
}
