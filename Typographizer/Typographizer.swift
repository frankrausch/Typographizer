//
//  Typographizer.swift
//  Typographizer
//
//  Created by Frank Rausch on 2017-01-02.
//  Copyright © 2017 Frank Rausch.
//

import Foundation

struct Typographizer {

    enum TypographizerTokenResult: String {
        case openingSingle = "opening-single"
        case closingSingle = "closing-single"
        case openingDouble = "opening-double"
        case closingDouble = "closing-double"
        case apostrophe = "apostrophe"
        case enDash = "en-dash"
        // Unchanged text because it doesn’t contain the trigger characters:
        case unchanged = "unchanged"
        // It’s one of the trigger characters but didn’t need changing:
        case ignored = "ignored"
        // Was skipped because it was either a tag, or protected text between tags.
        case skipped = "skipped"
    }
    
    struct TypographizerToken {
        let result: TypographizerTokenResult
        let text: String
        
        init(_ result: TypographizerTokenResult, _ text: String) {
            self.result = result
            self.text = text
        }
    }

    var language: String {
        didSet {
            self.refreshLanguage()
        }
    }
    
    var text = "" {
        didSet {
            self.refreshTextIterator()
        }
    }
    
    private var textIterator: String.UnicodeScalarView.Iterator?
    private var bufferedScalar: UnicodeScalar?
    private var previousScalar: UnicodeScalar?

    var isDebugModeEnabled = false
    var isHTML = false
    
    private var openingDoubleQuote: String = "·"
    private var closingDoubleQuote: String = "·"
    private var openingSingleQuote: String = "·"
    private var closingSingleQuote: String = "·"
    
    private let apostrophe: String = "’"
    private let enDash: String = "–"
    private let tagsToSkip = ["pre", "code", "var", "samp", "kbd", "math", "script", "style"]
    private let openingBracketsArray: [UnicodeScalar] = ["(", "["]
    
    init(language: String, text: String, isHTML: Bool = false) {
        self.text = text
        self.isHTML = isHTML
        self.language = language
        
        self.refreshLanguage()
        self.refreshTextIterator()
    }
    
    private mutating func refreshLanguage() {
        switch self.language {
        case "he":
            // TODO: Insert proper replacements. 
            // Fixing dumb quotation marks in Hebrew is tricky,
            // because a dumb double quotation mark may also be used for gershayim.
            // See https://en.wikipedia.org/wiki/Gershayim
            self.openingDoubleQuote = "\""
            self.closingDoubleQuote = "\""
            self.openingSingleQuote = "\'"
            self.closingSingleQuote = "\'"
        case "cs",
             "da",
             "de",
             "et",
             "is",
             "lt",
             "lv",
             "sk",
             "sl":
            self.openingDoubleQuote = "„"
            self.closingDoubleQuote = "“"
            self.openingSingleQuote = "\u{201A}"
            self.closingSingleQuote = "‘"
        case "bs",
             "fi",
             "sv":
            self.openingDoubleQuote = "”"
            self.closingDoubleQuote = "”"
            self.openingSingleQuote = "’"
            self.closingSingleQuote = "’"
        case "fr":
            self.openingDoubleQuote = "«\u{00A0}"
            self.closingDoubleQuote = "\u{00A0}»"
            self.openingSingleQuote = "‹\u{00A0}"
            self.closingSingleQuote = "\u{00A0}›"
        case "hu",
             "pl",
             "ro":
            self.openingDoubleQuote = "„"
            self.closingDoubleQuote = "”"
            self.openingSingleQuote = "’"
            self.closingSingleQuote = "’"
        case "ja":
            self.openingDoubleQuote = "「"
            self.closingDoubleQuote = "」"
            self.openingSingleQuote = "『"
            self.closingSingleQuote = "』"
        case "ru",
             "no",
             "nn":
            self.openingDoubleQuote = "«"
            self.closingDoubleQuote = "»"
            self.openingSingleQuote = "’"
            self.closingSingleQuote = "’"
        case "en",
             "nl": // contemporary Dutch style
            fallthrough
        default:
            self.openingDoubleQuote = "“"
            self.closingDoubleQuote = "”"
            self.openingSingleQuote = "‘"
            self.closingSingleQuote = "’"
        }
    }
    
    mutating func refreshTextIterator() {
        self.textIterator = self.text.unicodeScalars.makeIterator()
    }
    
    mutating func typographize() -> String {
        #if DEBUG
            let startTime = Date()
        #endif
        
        var tokens = [TypographizerToken]()
        do {
            while let token = try self.nextToken() {
                tokens.append(token)
            }
        } catch {
            #if DEBUG
                print("Typographizer iterator triggered an error.")
                abort()
            #endif
        }
        
        let s = tokens.flatMap({$0.text}).joined()
        
        #if DEBUG
            let endTime = Date().timeIntervalSince(startTime)
            print("Typographizing took \(NSString(format:"%.8f", endTime)) seconds")
        #endif
        
        return s
    }
    
    
    private mutating func nextToken() throws -> TypographizerToken? {
        while let ch = nextScalar() {
            switch ch {
            case "´",
                 "`":
                // FIXME: Replacing a combining accent only works for the very first scalar in a string
                return TypographizerToken(.apostrophe, "’")
            case "\"",
                 "'",
                 "-":
                return try self.fixableToken(ch)
            case "<" where self.isHTML:
                return try self.tagToken()
            default:
                return try self.stringToken(ch)
            }
        }
        return nil
    }
    
    private mutating func nextScalar() -> UnicodeScalar? {
        if let next = bufferedScalar {
            bufferedScalar = nil
            return next
        }
        return textIterator?.next()
    }
    
    // MARK: Tag Token
    
    private mutating func tagToken() throws -> TypographizerToken {
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
        return TypographizerToken(.skipped, tokenText)
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
    
    // MARK: String Token
    
    private mutating func stringToken(_ first: UnicodeScalar) throws -> TypographizerToken {
        var tokenText = String(first)
        self.previousScalar = first
        
        loop: while let ch = nextScalar() {
            switch ch {
            case "\"", "'", "<", "-":
                bufferedScalar = ch
                break loop
            default:
                self.previousScalar = ch
                tokenText.unicodeScalars.append(ch)
            }
        }
        return TypographizerToken(.unchanged, tokenText)
    }
    
    // MARK: Fixable Token (quote, apostrophe, hyphen)
    
    private mutating func fixableToken(_ first: UnicodeScalar) throws -> TypographizerToken {
        var tokenText = String(first)
        
        let nextScalar = self.nextScalar()
        self.bufferedScalar = nextScalar
        
        var fixingResult: TypographizerTokenResult = .ignored
        
        switch first {
        case "\"":
            if let previousScalar = self.previousScalar,
                let nextScalar = nextScalar {
                if CharacterSet.whitespacesAndNewlines.contains(previousScalar) || self.openingBracketsArray.contains(previousScalar) {
                    tokenText = self.openingDoubleQuote
                    fixingResult = .openingDouble
                } else if CharacterSet.whitespacesAndNewlines.contains(nextScalar) || CharacterSet.punctuationCharacters.contains(nextScalar) {
                    tokenText = self.closingDoubleQuote
                    fixingResult = .closingDouble
                } else {
                    tokenText = self.closingDoubleQuote
                    fixingResult = .closingDouble
                }
            } else {
                if previousScalar == nil {
                    // The last character of a string:
                    tokenText = self.openingDoubleQuote
                    fixingResult = .openingDouble
                } else {
                    // The first character of a string:
                    tokenText = self.closingDoubleQuote
                    fixingResult = .closingDouble
                }
            }
            
        case "'":
            if let previousScalar = self.previousScalar,
                let nextScalar = nextScalar {
                
                if CharacterSet.whitespacesAndNewlines.contains(previousScalar)
                    || CharacterSet.punctuationCharacters.contains(previousScalar) && !CharacterSet.whitespacesAndNewlines.contains(nextScalar)
                {
                    tokenText = self.openingSingleQuote
                    fixingResult = .openingSingle
                } else if CharacterSet.whitespacesAndNewlines.contains(nextScalar) || CharacterSet.punctuationCharacters.contains(nextScalar) {
                    tokenText = self.closingSingleQuote
                    fixingResult = .closingSingle
                } else {
                    tokenText = self.apostrophe
                    fixingResult = .apostrophe
                }
            } else {
                if previousScalar == nil {
                    // The first character of a string:
                    tokenText = self.openingSingleQuote
                    fixingResult = .openingSingle
                } else {
                    // The last character of a string:
                    tokenText = self.closingSingleQuote
                    fixingResult = .closingSingle
                }
            }
        case "-":
            if let previousScalar = self.previousScalar,
                let nextScalar = nextScalar,
                CharacterSet.whitespacesAndNewlines.contains(previousScalar)
                && CharacterSet.whitespacesAndNewlines.contains(nextScalar)
            {
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
        return TypographizerToken(fixingResult, tokenText)
    }
    
}
