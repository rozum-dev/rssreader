//
//  RSSParser.swift
//  rssreader
//
//  Created by Dmytro Rozumeyenko on 1/31/17.
//  Copyright © 2017 Appload. All rights reserved.
//

import Foundation

let RSSParserErrorDomain = "RSSParserErrorDomain"
private let kItemElementName = "item"
private let kImageMimetypes = ["image/jpeg", "mage/png"]

class RSSParser: NSObject, XMLParserDelegate {
    
    private var parser:XMLParser!
    private var completionHandler: (([Dictionary<String, String>]?, Error?) -> Void)?
    private var error:Error?
    
    private var arrParsedData = [Dictionary<String, String>]()
    private var currentItemDictionary = Dictionary<String, String>()
    private var currentElement = ""
    private var currentElementAttributes = Dictionary<String,String>()
    private var isItemElementInProgress = false
    private var foundCharacters = ""
    
    init(with data: Data) {
        super.init()
        parser = XMLParser(data: data)
        parser.delegate = self
    }
    
    func parse(completionHandler: @escaping ([Dictionary<String, String>]?, Error?) -> Void) {
        self.completionHandler = completionHandler
        parser.parse()
    }

    //MARK: XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == kItemElementName {
            isItemElementInProgress = true
        }
        currentElement = elementName
        currentElementAttributes = attributeDict
        
        if currentElement == ItemFields.enclosure.rawValue, let enclosureUrl = currentElementAttributes["url"], let mimeType = currentElementAttributes["type"] {
            if kImageMimetypes.contains(mimeType) {
                if currentItemDictionary[currentElement] == nil {
                    currentItemDictionary[currentElement] = enclosureUrl
                }
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if isItemElementInProgress, RSSParser.isItemField(elementName: currentElement) {
            foundCharacters += string
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if isItemElementInProgress, RSSParser.isItemField(elementName: currentElement) {
            if !foundCharacters.isEmpty {
                if currentItemDictionary[currentElement] == nil {
                    currentItemDictionary[currentElement] = foundCharacters
                }
                
                foundCharacters = ""
                currentElement = ""
            }
        }
        
        if elementName == kItemElementName {
            isItemElementInProgress = false
            arrParsedData.append(currentItemDictionary)
            currentItemDictionary = [:]
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        completionHandler?(arrParsedData, error)
        completionHandler = nil
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        error = parseError
    }
    
    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        error = validationError
    }
    
    //MARK:
    static private func isItemField(elementName:String) -> Bool {
        if let _ = ItemFields(rawValue: elementName) {
            return true
        } else {
            return false
        }
    }
    
    static private func parsingError() -> Error {
        return NSError(domain: RSSParserErrorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey : "invalid XML"])
    }
    
}
