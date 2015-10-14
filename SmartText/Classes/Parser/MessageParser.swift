//
//  MessageParser.swift
//  SearchApp
//
//  Created by Alex K. on 02/10/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import Foundation

class MessageParser {
    
    let patterns : [(key:String, regex:String, textAtrribut:[String : NSObject])]
    let text: NSAttributedString
    
    var parseObjects:Array<(key:String, range:NSRange)> = Array<(key:String, range:NSRange)>()
    
    var attributeDidChaged: ((attributedString : NSAttributedString) -> ())?
    
    // MARK: life cicle
    
    init(text:NSAttributedString, patterns:[(key:String, regex:String, textAtrribut:[String : NSObject])]) {
        self.patterns = patterns
        self.text = text;
    }
    
    // MARK: create
    
    func configureAtrributString(text:NSAttributedString, patterns:[(key:String, regex:String, textAtrribut:[String : NSObject])]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(attributedString: text)
        
        for pattern in patterns {
            let ranges = Regex(pattern.regex).found(text.string)
            addAttributes(attributedString, key:pattern.key, attrs: pattern.textAtrribut, ranges: ranges)
        }
        
        return attributedString;
    }
    
    // MARK: helpers
    
    func addAttributes(attributedString:NSMutableAttributedString, key:String, attrs:[String : NSObject], ranges:[NSRange]) {
        for range in ranges {
            attributedString.addAttributes(attrs, range:range)
            
            // added parse object
            let parseObject = (key:key, range:range)
            parseObjects.append(parseObject)
        }
    }
    
    // MARK: public
    
    func startParse() {
        if (attributeDidChaged != nil) {
            let attributedString = configureAtrributString(text, patterns: patterns)
            attributeDidChaged!(attributedString: attributedString)
        }
    }
    
    func foundParseObject(index:Int, completion:(parseObject:(key:String, value:String)?) -> Void) {

        var currentParseObject : (key:String, range:NSRange)!
        for parseObject in parseObjects {
            if NSLocationInRange(index, parseObject.range) {
                currentParseObject = parseObject
            }
        }
        
        if (currentParseObject != nil) {
            let value = text.attributedSubstringFromRange(currentParseObject.range)
            completion(parseObject: (key:currentParseObject.key, value:value.string))
        } else {
            completion(parseObject: nil)
        }
    }
    
}
