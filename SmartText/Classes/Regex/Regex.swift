//
//  Regex.swift
//  SearchApp
//
//  Created by Alex K. on 01/10/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import Foundation

class Regex {
    let internalExpression: NSRegularExpression?
    let pattern: String
    
    init(_ pattern: String) {
        self.pattern = pattern
        self.internalExpression = NSRegularExpression(pattern: pattern, options: .DotMatchesLineSeparators, error:nil)
    }
    
    func found(text: String) -> [NSRange]
    {
        let range = NSMakeRange(0, (text as NSString).length)
        let matches = self.internalExpression?.matchesInString(text, options: nil, range:range)
        var ranges = [NSRange]()
        if let matches = matches
        {
            ranges = matches.map { object in
                return object.range;
            }
        }
        return ranges
    }
}