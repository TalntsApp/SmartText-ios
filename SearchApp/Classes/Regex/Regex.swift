//
//  Regex.swift
//  SearchApp
//
//  Created by Alex K. on 01/10/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import Foundation

class Regex {
    let internalExpression: NSRegularExpression
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = try! NSRegularExpression(pattern: pattern, options: [.DotMatchesLineSeparators])
    }
    
    func found(text: String) -> [NSRange] {
        let matches = self.internalExpression.matchesInString(text, options: [], range: NSMakeRange(0, text.characters.count))
        let ranges = matches.map { (let object: NSTextCheckingResult) -> NSRange in
            return object.range;
        }
        return ranges
    }
}