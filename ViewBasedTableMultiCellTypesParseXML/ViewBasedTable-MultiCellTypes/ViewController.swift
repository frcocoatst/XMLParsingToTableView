//
//  ViewController.swift
//  ViewBasedTable-MultiCellTypes
//
//  Created by Debasis Das on 5/15/17.
//  Copyright © 2017 Knowstack. All rights reserved.
//

import Cocoa

class Book {
    var bookTitle: String = String()
    var bookAuthor: String = String()
}

var books: [Book] = []
var eName: String = String()
var bookTitle = String()
var bookAuthor = String()


class ViewController: NSViewController, XMLParserDelegate {
    @IBOutlet weak var tableView:NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //
        guard let urlPath = Bundle.main.path(forResource: "books", ofType: "xml") else {
            print("Can't load file")
            return
        }
        let url:URL = URL(fileURLWithPath: urlPath)
        
        if let parser = XMLParser(contentsOf: url) {
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
                // printout each book of books array
                for b in books
                {
                    print(b.bookTitle + " - " + b.bookAuthor)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    /* Parser functions */
    // 1
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "book" {
            bookTitle = String()
            bookAuthor = String()
        }
    }
    
    // 2
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "book" {
            let book = Book()
            book.bookTitle = bookTitle
            book.bookAuthor = bookAuthor
            
            books.append(book)
        }
    }
    
    // 3
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (!data.isEmpty) {
            if eName == "title" {
                bookTitle += data
                // print(bookTitle)
            } else if eName == "author" {
                bookAuthor += data
                // print(bookAuthor)
            }
        }
    }

}

extension ViewController:NSTableViewDataSource, NSTableViewDelegate{
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        // return count
        return books.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        
        /*
        if (tableColumn?.identifier)!.rawValue == "bookAuthor" {
            return books[row].bookAuthor
        }
        else
        {
            return books[row].bookTitle
        }
        
        if (tableColumn?.identifier)!.rawValue == "imageIcon"{
            let result = tableView.makeView(withIdentifier: "NSUser", owner: self) as! NSTableCellView
            result.imageView?.image = NSImage(named:NSImage.Name(rawValue: tableViewData[row]["imageIcon"]!))
            return result
        }
        else if (tableColumn?.identifier)!.rawValue == "jobTitle"{
            let result:NSPopUpButton = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "jobTitle"), owner: self) as! NSPopUpButton
            result.selectItem(withTitle: tableViewData[row]["jobTitle"]!)
            return result
        }
        else
        */
        if (tableColumn?.identifier)!.rawValue == "imageIcon"{
            let result = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "imageIcon"), owner: self) as! NSTableCellView
            
            if (row % 2 == 0){
                result.imageView?.image = NSImage(named:NSImage.Name(rawValue: "NSUser"))
            }
            else
            {
                result.imageView?.image = NSImage(named:NSImage.Name(rawValue: "NSUserGroup"))
            }
            return result
        }
        else
        {
            let result = tableView.makeView(withIdentifier:(tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
            if (tableColumn?.identifier)!.rawValue == "bookAuthor" {
                result.textField?.stringValue = books[row].bookAuthor
            }
            else
            {
                result.textField?.stringValue = books[row].bookTitle
            }
            // result.textField?.stringValue = books[row].(tableColumn?.identifier)!.rawValue!
            return result
            
        }
    }
}


