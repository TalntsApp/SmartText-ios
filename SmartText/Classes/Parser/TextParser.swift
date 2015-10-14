
import Foundation

struct Pattern
{
    let key:String
    let regex:String
    let attributes:[String : NSObject]
}

struct PatternObject
{
    let key:String
    let range:NSRange
    let attributes:[String : NSObject]
}

class TextParser
{
    let patterns : [Pattern]
    let text: NSAttributedString
    var patternsObjects = [PatternObject]()
    
    init(text:NSAttributedString, patterns:[Pattern])
    {
        self.patterns = patterns
        self.text = text;
    }
    
    private func addAttributes(attributedString:NSMutableAttributedString, key:String, attributes:[String : NSObject], ranges:[NSRange])
    {
        for range in ranges
        {
            attributedString.addAttributes(attributes, range:range)
            let pattern = PatternObject(key:key, range:range, attributes:attributes)
            patternsObjects.append(pattern)
        }
    }
    
    func parse() -> NSAttributedString
    {
        return self.parse(text, patterns: patterns)
    }
    
    func parse(text:NSAttributedString, patterns:[Pattern]) -> NSAttributedString
    {
        let attributedString = NSMutableAttributedString(attributedString: text)
        for pattern in patterns
        {
            let ranges = Regex(pattern.regex).found(text.string)
            addAttributes(attributedString, key:pattern.key, attributes: pattern.attributes, ranges: ranges)
        }
        return attributedString
    }
    
    func findPattern(index:Int) -> (key:String, value:String)?
    {
        var seekingPattern: PatternObject? = nil
        
        for pattern in patternsObjects
        {
            if NSLocationInRange(index, pattern.range)
            {
                seekingPattern = pattern
            }
        }
        
        if let pattern = seekingPattern
        {
            let value = text.attributedSubstringFromRange(pattern.range)
            return (key:pattern.key, value:value.string)
        }
        return nil
    }
}
