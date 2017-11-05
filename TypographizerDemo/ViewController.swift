//
//  ViewController.swift
//  TypographizerDemo
//
//  Created by Frank Rausch on 2017-03-15.
//  Copyright © 2017 Frank Rausch. All rights reserved.
//

import Cocoa

import Typographizer

class ViewController: NSViewController, NSTextViewDelegate {
    
    @IBOutlet weak var beforeTextView: NSTextView! {
        didSet {
            beforeTextView.delegate = self
        }
    }
    
    @IBOutlet weak var afterTextView: NSTextView!
    
    @IBOutlet weak var languageCodePopUpButton: NSPopUpButton!
    
    @IBOutlet weak var htmlCheckbox: NSButton!
    @IBOutlet weak var debugCheckbox: NSButton!
    @IBOutlet weak var measurePerformanceCheckbox: NSButton!
    
    let supportedLanguageCodes = [
        "bs",
        "cs",
        "da",
        "de",
        "de_CH",
        "en",
        "et",
        "fi",
        "fr",
        "he",
        "hu",
        "is",
        "ja",
        "lt",
        "lv",
        "nl",
        "nn",
        "no",
        "pl",
        "ro",
        "ru",
        "sk",
        "sl",
        "sv",
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let font = NSFont(name: "Menlo", size: 20)
        self.beforeTextView.font = font
        self.afterTextView.font = font
        
        self.languageCodePopUpButton.removeAllItems()
        self.languageCodePopUpButton.addItems(withTitles: self.supportedLanguageCodes)
        self.languageCodePopUpButton.selectItem(withTitle: "en")
        
        self.beforeTextView.string = "\"This 'magic' piece of code fixes dumb quotes and apostrophes.\"\n\n<p class=\"intro\">\n  It doesn't 'break' HTML.\n</p>\n\n<code>\n  let s = \"Hello, world!\"\n</code>"
        
        self.refresh()
    }
    
    private func refresh() {
        var s: String = self.beforeTextView.string
        
        let language = self.languageCodePopUpButton.titleOfSelectedItem ?? "en"
        let isHTML: Bool = self.htmlCheckbox.state == .on
        let debug: Bool = self.debugCheckbox.state == .on
        let measurePerformance: Bool = self.measurePerformanceCheckbox.state == .on
        
        // This is where the magic happens:
        s = s.typographized(language: language, isHTML: isHTML, debug: debug, measurePerformance: measurePerformance)
        
        self.afterTextView.string = s
    }
    
    func textDidChange(_ notification: Notification) {
        self.refresh()
    }
    
    @IBAction func debugCheckboxDidChange(_ sender: Any) {
        self.refresh()
    }
    
    @IBAction func htmlCheckboxDidChange(_ sender: Any) {
        self.refresh()
    }
    @IBAction func measurePerformanceCheckboxDidChange(_ sender: Any) {
        self.refresh()
    }
    
    @IBAction func languageCodePopUpButtonDidChange(_ sender: NSPopUpButton) {
        self.refresh()
    }
}

