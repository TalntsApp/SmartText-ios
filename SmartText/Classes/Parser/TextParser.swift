
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
    let string:String
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
    
    func parse() -> NSAttributedString
    {
        return self.parse(text, patterns: patterns)
    }
    
    func parse(text:NSAttributedString, patterns:[Pattern]) -> NSAttributedString
    {
        let (string,patternsObjects) = createPatternString(text, patterns)
        self.patternsObjects = patternsObjects
        return string
    }
    
    func findPattern(index:Int) -> PatternObject?
    {
        let po = findPatternInString(patternsObjects, index)
        return po
    }
}

func createPatternString(text:NSAttributedString, patterns:[Pattern]) -> (NSAttributedString, [PatternObject])
{
    let attributedString = NSMutableAttributedString(attributedString: text)
    var patternsObjects = [PatternObject]()
    for pattern in patterns
    {
        let ranges = Regex(pattern.regex).found(text.string)
        for range in ranges
        {
            attributedString.addAttributes(pattern.attributes, range:range)
            let s = text.attributedSubstringFromRange(range)
            let p = PatternObject(key:pattern.key, range:range, string:s.string, attributes:pattern.attributes)
            patternsObjects.append(p)
        }
    }
    return (attributedString, patternsObjects)
}

func findPatternInString(allPatternsObjects:[PatternObject], index:Int) -> PatternObject?
{
    var seekingPattern: PatternObject? = nil
    for pattern in allPatternsObjects
    {
        if NSLocationInRange(index, pattern.range)
        {
            seekingPattern = pattern
        }
    }
    return seekingPattern
}

