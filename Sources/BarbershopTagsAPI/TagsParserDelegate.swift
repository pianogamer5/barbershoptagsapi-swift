//
//  TagsParserDelegate.swift
//  BarbershopTagsAPI
//
//  Created by Carson Greene on 2/1/22.
//

import Foundation

class TagsParserDelegate: NSObject, XMLParserDelegate {
    var tags: TagQueryResult?

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        print(elementName, attributeDict)
    }
}
