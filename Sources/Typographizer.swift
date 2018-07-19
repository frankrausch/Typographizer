//
//  Typographizer.swift
//  Typographizer
//
//  Created by Frank Rausch on 2017-01-02.
//  Copyright © 2017 Frank Rausch.
//

import Foundation

public struct Typographizer {

    private var locale: NSLocale
    var text = "" {
        didSet {
            self.refreshTextIterator()
        }
    }

    private var textIterator: String.UnicodeScalarView.Iterator?
    private var bufferedScalar: UnicodeScalar?
    private var previousScalar: UnicodeScalar?

    var isDebugModeEnabled = false
    var isMeasurePerformanceEnabled = false
    var isHTML = false

    private let apostrophe: String = "’"
    private let enDash: String = "–"
    private let tagsToSkip: Set<String> = ["pre", "code", "var", "samp", "kbd", "math", "script", "style"]
    private let openingBracketsSet: Set<UnicodeScalar> = ["(", "["]

    init(locale: NSLocale, text: String, isHTML: Bool = false, debug: Bool = false, measurePerformance: Bool = false) {
        self.locale = locale
        self.text = text
        self.isHTML = isHTML
        self.isDebugModeEnabled = debug
        self.isMeasurePerformanceEnabled = measurePerformance

        self.refreshTextIterator()
    }

    mutating func refreshTextIterator() {
        self.textIterator = self.text.unicodeScalars.makeIterator()
    }

    mutating func typographize() -> String {
        #if DEBUG
            var startTime: Date?
            if self.isMeasurePerformanceEnabled {
                startTime = Date()
            }
        #endif

        var tokens = [Token]()
        do {
            while let token = try self.nextToken() {
                tokens.append(token)
            }
        } catch {
                if self.isDebugModeEnabled {
                    #if DEBUG
                        print("Typographizer iterator triggered an error.")
                        abort()
                    #endif
                } else {
                    return self.text // return unchanged text
                }
        }

        let s = tokens.compactMap({$0.text}).joined()

        #if DEBUG
            if let startTime = startTime {
                let endTime = Date().timeIntervalSince(startTime)
                print("Typographizing took \(NSString(format:"%.8f", endTime)) seconds")
            }
        #endif

        return s
    }

    private mutating func nextToken() throws -> Token? {
        while let ch = self.nextScalar() {
            switch ch {
            case "´",
                 "`":
                // FIXME: Replacing a combining accent only works for the very first scalar in a string
                return Token(.apostrophe, self.apostrophe)
            case "\"",
                 "'",
                 "-":
                return try self.fixableToken(ch)
            case "<" where self.isHTML:
                return try self.htmlToken()
            default:
                return try self.unchangedToken(ch)
            }
        }
        return nil
    }

    private mutating func nextScalar() -> UnicodeScalar? {
        if let next = self.bufferedScalar {
            self.bufferedScalar = nil
            return next
        }
        return self.textIterator?.next()
    }

    // MARK: Tag Token

    private mutating func htmlToken() throws -> Token {
        var tokenText = "<"
        var tagName = ""
        loop: while let ch = nextScalar() {
            switch ch {
            case " " where self.tagsToSkip.contains(tagName),
                 ">" where self.tagsToSkip.contains(tagName):
                tokenText.unicodeScalars.append(ch)
                tokenText.append(self.fastForwardToClosingTag(tagName))
                break loop
            case ">":
                tokenText.unicodeScalars.append(ch)
                break loop
            default:
                tagName.unicodeScalars.append(ch)
                tokenText.unicodeScalars.append(ch)
            }
        }
        return Token(.skipped, tokenText)
    }

    private mutating func fastForwardToClosingTag(_ tag: String) -> String {
        var buffer = ""

        loop: while let ch = nextScalar() {
            buffer.unicodeScalars.append(ch)
            if ch == "<" {
                if let ch = nextScalar() {
                    buffer.unicodeScalars.append(ch)
                    if ch == "/" {
                        let (bufferedString, isMatchingTag) = self.checkForMatchingTag(tag)
                        buffer.append(bufferedString)
                        if isMatchingTag {
                            break loop
                        }
                    }
                }
            }
        }
        return buffer
    }

    private mutating func checkForMatchingTag(_ tag: String) -> (bufferedString: String, isMatchingTag: Bool) {
        var buffer = ""
        loop: while let ch = nextScalar() {
            buffer.unicodeScalars.append(ch)
            if ch == ">" {
                break loop
            }

        }
        return (buffer, buffer.hasPrefix(tag))
    }

    // MARK: Unchanged Token

    private mutating func unchangedToken(_ first: UnicodeScalar) throws -> Token {
        var tokenText = String(first)
        self.previousScalar = first

        loop: while let ch = nextScalar() {
            switch ch {
            case "\"", "'", "<", "-":
                self.bufferedScalar = ch
                break loop
            default:
                self.previousScalar = ch
                tokenText.unicodeScalars.append(ch)
            }
        }
        return Token(.unchanged, tokenText)
    }

    // MARK: Fixable Token (quote, apostrophe, hyphen)

    private mutating func fixableToken(_ first: UnicodeScalar) throws -> Token {
        var tokenText = String(first)

        let nextScalar = self.nextScalar()
        self.bufferedScalar = nextScalar

        var fixingResult: Result = .ignored

        switch first {
        case "\"":
            if let previousScalar = self.previousScalar,
                let nextScalar = nextScalar {
                if CharacterSet.whitespacesAndNewlines.contains(previousScalar) || self.openingBracketsSet.contains(previousScalar) {
                    tokenText = self.locale.quotationBeginDelimiter
                    fixingResult = .openingDouble
                } else if CharacterSet.whitespacesAndNewlines.contains(nextScalar) || CharacterSet.punctuationCharacters.contains(nextScalar) {
                    tokenText = self.locale.quotationEndDelimiter
                    fixingResult = .closingDouble
                } else {
                    tokenText = self.locale.quotationEndDelimiter
                    fixingResult = .closingDouble
                }
            } else {
                if self.previousScalar == nil {
                    // The last character of a string:
                    tokenText = self.locale.quotationBeginDelimiter
                    fixingResult = .openingDouble
                } else {
                    // The first character of a string:
                    tokenText = self.locale.quotationEndDelimiter
                    fixingResult = .closingDouble
                }
            }

        case "'":
            if let previousScalar = self.previousScalar,
                let nextScalar = nextScalar {

                if CharacterSet.whitespacesAndNewlines.contains(previousScalar)
                    || CharacterSet.punctuationCharacters.contains(previousScalar) && !CharacterSet.whitespacesAndNewlines.contains(nextScalar) {
                    tokenText = self.locale.alternateQuotationBeginDelimiter
                    fixingResult = .openingSingle
                } else if CharacterSet.whitespacesAndNewlines.contains(nextScalar) || CharacterSet.punctuationCharacters.contains(nextScalar) {
                    tokenText = self.locale.alternateQuotationEndDelimiter
                    fixingResult = .closingSingle
                } else {
                    tokenText = self.apostrophe
                    fixingResult = .apostrophe
                }
            } else {
                if self.previousScalar == nil {
                    // The first character of a string:
                    tokenText = self.locale.alternateQuotationBeginDelimiter
                    fixingResult = .openingSingle
                } else {
                    // The last character of a string:
                    tokenText = self.locale.alternateQuotationEndDelimiter
                    fixingResult = .closingSingle
                }
            }
        case "-":
            if let previousScalar = self.previousScalar,
                let nextScalar = nextScalar,
                CharacterSet.whitespacesAndNewlines.contains(previousScalar)
                && CharacterSet.whitespacesAndNewlines.contains(nextScalar) {
                tokenText = self.enDash
                fixingResult = .enDash
            }
        default: ()
        }

        self.previousScalar = tokenText.unicodeScalars.last

        #if DEBUG
            if self.isDebugModeEnabled && self.isHTML {
                tokenText = "<span class=\"typographizer-debug typographizer-debug--\(fixingResult.rawValue)\">\(tokenText)</span>"
            }
        #endif
        return Token(fixingResult, tokenText)
    }
}

extension Typographizer {
    
    enum Result: String {
        case openingSingle = "opening-single"
        case closingSingle = "closing-single"
        case openingDouble = "opening-double"
        case closingDouble = "closing-double"
        case apostrophe
        case enDash = "en-dash"
        // Unchanged text because it doesn’t contain the trigger characters:
        case unchanged
        // It’s one of the trigger characters but didn’t need changing:
        case ignored
        // Was skipped because it was either an HTML tag, or a pair of tags with protected text in between:
        case skipped
    }
    
    struct Token {
        let result: Result
        let text: String
        
        init(_ result: Result, _ text: String) {
            self.result = result
            self.text = text
        }
    }
}
