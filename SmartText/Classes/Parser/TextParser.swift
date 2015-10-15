
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
    var patterns : [Pattern] { didSet{ self.parse() } }
    var text: String { didSet{ self.parse() } }
    var patternsObjects = [PatternObject]()
    
    init(text:String, patterns:[Pattern])
    {
        self.patterns = patterns
        self.text = text;
    }
    
    func parse() -> NSAttributedString
    {
        return self.parse(text, patterns: patterns)
    }
    
    func parse(text:String, patterns:[Pattern]) -> NSAttributedString
    {
        let (string,patternsObjects) = createPatternString(text, patterns)
        self.patternsObjects = patternsObjects
        return string
    }
    
    func findPattern(index:Int) -> PatternObject?
    {
        let po = findPatternInString(text, patternsObjects, index)
        return po
    }
}

func createPatternString(text:String, patterns:[Pattern]) -> (NSAttributedString, [PatternObject])
{
    let attributedString = NSMutableAttributedString(string: text)
    var patternsObjects = [PatternObject]()
    for pattern in patterns
    {
        let ranges = Regex(pattern.regex).found(text)
        for range in ranges
        {
            attributedString.addAttributes(pattern.attributes, range:range)
            let s = (text as NSString).substringWithRange(range)
            let p = PatternObject(key:pattern.key, range:range, string:s, attributes:pattern.attributes)
            patternsObjects.append(p)
        }
    }
    return (attributedString, patternsObjects)
}

func findPatternInString(text:String, allPatternsObjects:[PatternObject], index:Int) -> PatternObject?
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

