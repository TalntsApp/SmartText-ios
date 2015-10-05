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
    
    var parser : MessageParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testLabel.userInteractionEnabled = true;
        testLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        testLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"onDescriptionLabelTapped:"))
        
        
        // create mail pattern
        let mailAttributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.yellowColor(), NSUnderlineStyleAttributeName: 1]
        let emailregex = "[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*"
        let mailPattern = (key:"mail", regex:emailregex, textAtrribut:mailAttributes)
        
        // Hashtags
        let hashtagAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSBackgroundColorAttributeName: UIColor.redColor(), NSUnderlineStyleAttributeName: 1]
        let hashtagRegex = "(?<!\\w)#([\\w\\_]+)?"
        let hashtagPattern = (key:"hashtag", regex:hashtagRegex, textAtrribut:hashtagAttributes)
        
        // user 
        let userAttributes = [NSForegroundColorAttributeName: UIColor.blueColor(), NSBackgroundColorAttributeName: UIColor.redColor(), NSUnderlineStyleAttributeName: 1]
        let userRegex = "(?<!\\w)@([\\w\\_]+)?"
        let userPattern = (key:"user", regex:userRegex, textAtrribut:userAttributes)
        
        // create parser
        parser = MessageParser(text: testLabel.attributedText!, patterns:[mailPattern, hashtagPattern, userPattern])

        parser.attributeDidChaged = {(attributedString: NSAttributedString) -> () in
            self.testLabel.attributedText = attributedString
        }
        
        parser.startParse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        layoutManager.characterIndexForPoint(tapLocation, inTextContainer: textContainer, fractionOfDistanceBetweenInsertionPoints:nil) // magic line ???
        
        let offset = textOffser(layoutManager, textContainer: textContainer)
        tapLocation = CGPointMake(tapLocation.x - offset.x, tapLocation.y - offset.y)

        let index = layoutManager.glyphIndexForPoint(tapLocation, inTextContainer: textContainer)
        
        print("newindex: \(index)")
        
        parser.foundParseObject(index) { (parseObject) -> Void in
            if (parseObject != nil) {
                print("key: \(parseObject!.key) value:\(parseObject!.value)")
            } else {
                print("object not found")
            }
        }
    }

    // PRAGMA: helps
    
    func textOffser(layoutManager: NSLayoutManager, textContainer:NSTextContainer) ->CGPoint {
        var textOffset : CGPoint = CGPointZero
        var textBounds = layoutManager.usedRectForTextContainer(textContainer)
        textBounds.size.width = ceil(textBounds.size.width)
        textBounds.size.height = ceil(textBounds.size.height)
        
        if textBounds.size.height < self.testLabel.bounds.size.height {
            let paddingHeight = (self.testLabel.bounds.size.height - textBounds.size.height) / 2.0
            textOffset = CGPointMake(textOffset.x, paddingHeight)
        }
        return textOffset;
    }
}

