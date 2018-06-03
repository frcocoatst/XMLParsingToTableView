//
//  ViewController.swift
//  CellBasedTableViewBindingsXML
//
//  Created by Friedrich HAEUPL on 30.05.18.
//  Copyright © 2018 Friedrich HAEUPL. All rights reserved.
//

import Cocoa

/*
 Model:
 =====
 <item>
 <title>1 USD = 0.81722924 EUR</title>
 <link>http://www.floatrates.com/usd/eur/</link>
 <description>1 U.S. Dollar = 0.81722924 Euro</description>
 <pubDate>Fri, 6 Apr 2018 12:00:01 GMT</pubDate>
 <baseCurrency>USD</baseCurrency>
 <baseName>U.S. Dollar</baseName>
 <targetCurrency>EUR</targetCurrency>
 <targetName>Euro</targetName>
 <exchangeRate>0.81722924</exchangeRate>
 </item>
 */
class ExchangeRate : NSObject {
    @objc dynamic var rTitle: String = String()
    @objc dynamic var rLink: String = String()
    @objc dynamic var rDescription: String = String()
    @objc dynamic var rPubDate: String = String()
    @objc dynamic var rBaseCurrency: String = String()
    @objc dynamic var rBaseName: String = String()
    @objc dynamic var rTargetCurrency: String = String()
    @objc dynamic var rTargetName: String = String()
    @objc dynamic var rExchangeRate: String = String()
    
    override init() {
        rTitle = "Edit "
        rLink = "Edit "
        rDescription = "Edit "
        rPubDate = "Edit "
        rBaseCurrency = "Edit "
        rBaseName = "Edit "
        rTargetCurrency = "Edit "
        rTargetName = "Edit "
        rExchangeRate = "Edit "
        super.init()
    }
    
    init(rTitle:String, rLink:String, rDescription:String, rPubDate: String,
         rBaseCurrency: String , rBaseName: String, rTargetCurrency: String, rTargetName: String, rExchangeRate: String
         ) {
        self.rTitle = rTitle
        self.rLink = rLink
        self.rDescription = rDescription
        self.rPubDate = rPubDate
        self.rBaseCurrency = rBaseCurrency
        self.rBaseName = rBaseName
        self.rTargetCurrency = rTargetCurrency
        self.rTargetName = rTargetName
        self.rExchangeRate = rExchangeRate
        super.init()
    }
}

var eName: String = String()

var rTitle = String()
var rLink = String()
var rDescription = String()
var rPubDate = String()
var rBaseCurrency = String()
var rBaseName = String()
var rTargetCurrency = String()
var rTargetName = String()
var rExchangeRate = String()

class ViewController: NSViewController, XMLParserDelegate  {

     @objc dynamic var exchangeRates:[ExchangeRate] =  []
    
    /*
     Demodata
    @objc dynamic var exchangeRates:[ExchangeRate] =  [
        ExchangeRate(rTitle: "Title1", rLink: "Link1", rDescription: rDescription, rPubDate: rPubDate, rBaseCurrency: rBaseCurrency, rBaseName: rBaseName, rTargetCurrency: rTargetCurrency, rTargetName: rTargetName, rExchangeRate: rExchangeRate),
        ExchangeRate(rTitle: "Title2", rLink: "Link2", rDescription: rDescription, rPubDate: rPubDate, rBaseCurrency: rBaseCurrency, rBaseName: rBaseName, rTargetCurrency: rTargetCurrency, rTargetName: rTargetName, rExchangeRate: rExchangeRate)]
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        //
    }
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        eName = elementName
        
        if elementName == "item" {
            // create clean strings
            rTitle = String()
            rLink = String()
            rDescription = String()
            rPubDate = String()
            rBaseCurrency = String()
            rBaseName = String()
            rTargetCurrency = String()
            rTargetName = String()
            rExchangeRate = String()
        }
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            
            let exchangeRate : ExchangeRate = ExchangeRate(rTitle: rTitle, rLink: rLink, rDescription: rDescription, rPubDate: rPubDate, rBaseCurrency: rBaseCurrency, rBaseName: rBaseName, rTargetCurrency: rTargetCurrency, rTargetName: rTargetName, rExchangeRate: rExchangeRate)
            
            exchangeRates.append(exchangeRate)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
       
        if (!data.isEmpty) {
            if eName == "title" {
                rTitle += data
            }
            else if eName == "link" {
                rLink += data
            }
            else if eName == "description" {
                rDescription += data
            }
            else if eName == "pubDate" {
                rPubDate += data
            }
            else if eName == "baseCurrency" {
                rBaseCurrency += data
            }
            else if eName == "baseName" {
                rBaseName += data
            }
            else if eName == "targetCurrency" {
                rTargetCurrency += data
            }
            else if eName == "targetName" {
                rTargetName += data
            }
            else if eName == "exchangeRate" {
                rExchangeRate += data
            }
        }
    }

    @IBAction func loadAction(_ sender: Any) {
        
        guard let urlPath = Bundle.main.path(forResource: "usd", ofType: "xml") else {
            print("Can't load file")
            return
        }
        let url:URL = URL(fileURLWithPath: urlPath)
        
        if let parser = XMLParser(contentsOf: url) {
            print("XMLParser started")
            
            parser.delegate = self
            
            if !parser.parse(){
                print("Data Errors Exist:")
                let error = parser.parserError!
                print("Error Description:\(error.localizedDescription)")
                print("Line number: \(parser.lineNumber)")
            }
            else
            {
                // printout each exchangeRate of exchangeRates array
                for b in exchangeRates
                {
                    print(b.rTitle + " - " + b.rLink)
                }
            }
        }
    }
}

