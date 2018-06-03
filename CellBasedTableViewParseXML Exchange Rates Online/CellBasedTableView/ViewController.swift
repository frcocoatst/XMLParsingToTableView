//
//  ViewController.swift
//  CellBasedTableView
//
//  Created by Debasis Das on 5/15/17.
//  Copyright © 2017 Knowstack. All rights reserved.
//

//Cell based NSTableView using datasource.
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
class ExchangeRate {
    var rTitle: String = String()
    var rLink: String = String()
    var rDescription: String = String()
    var rPubDate: String = String()
    var rBaseCurrency: String = String()
    var rBaseName: String = String()
    var rTargetCurrency: String = String()
    var rTargetName: String = String()
    var rExchangeRate: String = String()
    
}
var exchangeRates: [ExchangeRate] = []
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


class ViewController: NSViewController, XMLParserDelegate, NSTableViewDataSource  {
    
    //@IBOutlet weak var tableView:NSTableView!
    @IBOutlet weak var tableView: NSTableView!
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        // return count
        return exchangeRates.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        
        if (tableColumn?.identifier)!.rawValue == "title" {
            return exchangeRates[row].rTitle
        }
        else if (tableColumn?.identifier)!.rawValue == "link" {
            return exchangeRates[row].rLink
        }
        else if (tableColumn?.identifier)!.rawValue == "pubDate" {
            return exchangeRates[row].rPubDate
        }
        else if (tableColumn?.identifier)!.rawValue == "baseName" {
            return exchangeRates[row].rBaseName
        }
        else{
            return exchangeRates[row].rTargetName
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self as? NSTableViewDelegate
        self.tableView.dataSource = self
        
        let url:String="http://www.floatrates.com/daily/usd.xml"
        let urlToReceive: URL = URL(string: url)!
        // Parse the XML
        if let parser = XMLParser(contentsOf: urlToReceive) {
            print("XMLParser ")
            
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
        self.tableView.reloadData()
    }
    
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "item" {
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
            let exchangeRate = ExchangeRate()
            exchangeRate.rTitle = rTitle
            exchangeRate.rLink = rLink
            exchangeRate.rDescription = rDescription
            exchangeRate.rPubDate = rPubDate
            exchangeRate.rBaseCurrency = rBaseCurrency
            exchangeRate.rBaseName = rBaseName
            exchangeRate.rTargetCurrency = rTargetCurrency
            exchangeRate.rTargetName = rTargetName
            exchangeRate.rExchangeRate = rExchangeRate
            
            exchangeRates.append(exchangeRate)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
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
}




