//
//  ViewController.swift
//  SearchApp
//
//  Created by Alex K. on 01/10/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testLabel: UILabel!
    
    var parser : TextParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.userInteractionEnabled = true;
        testLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        testLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"onDescriptionLabelTapped:"))
        
        
        // create mail pattern
        let mailAttributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.yellowColor(), NSUnderlineStyleAttributeName: 1]
        let emailregex = "[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*"
        let mailPattern = Pattern(key:"mail", regex:emailregex, attributes:mailAttributes)
        
        // Hashtags
        let hashtagAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSBackgroundColorAttributeName: UIColor.redColor(), NSUnderlineStyleAttributeName: 1]
        let hashtagRegex = "(?<!\\w)#([\\w\\_]+)?"
        let hashtagPattern = Pattern(key:"hashtag", regex:hashtagRegex, attributes:hashtagAttributes)
        
        // user 
        let userAttributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.redColor(), NSUnderlineStyleAttributeName: 1]
        let userRegex = "(?<!\\w)@([\\w\\_]+)?"
        let userPattern = Pattern(key:"user", regex:userRegex, attributes:userAttributes)
        
        // create parser
        parser = TextParser(text: (testLabel.text ?? ""), patterns:[mailPattern, hashtagPattern, userPattern])
        self.testLabel.attributedText = parser.parse()
    }
    
    // PRAGMA: actions
    func onDescriptionLabelTapped(recognizer:UITapGestureRecognizer)
    {
        let label = recognizer.view as! UILabel
        var tapLocation = recognizer.locationInView(label)
        
        
        // init text storage
        let textStorage: NSTextStorage = NSTextStorage(attributedString: label.attributedText!)
        let layoutManager: NSLayoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        // init text container
        let labelSize = CGSizeMake(label.frame.size.width, label.frame.size.height)
        let textContainer = NSTextContainer(size:labelSize)
        textContainer.maximumNumberOfLines = label.numberOfLines;
        textContainer.lineBreakMode = label.lineBreakMode;
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndexForPoint(tapLocation, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints:nil)
        println("newindex: \(index)")
        
        let parseObject = parser.findPattern(index)
        if let patternObject = parseObject
        {
            println("key: \(patternObject.key) value:\(patternObject.string)")
        }
        else
        {
            println("object not found")
        }
    }
}

