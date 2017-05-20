//
//  String+Typographizer.swift
//  Typographizer
//
//  Created by Frank Rausch on 2017-02-04.
//  Copyright © 2017 Frank Rausch.
//

import Foundation

extension String {
    
    public func typographized(locale: NSLocale, isHTML: Bool = false, debug: Bool = false, measurePerformance: Bool = false) -> String {
        var t = Typographizer(locale: locale, text: self)
        t.isHTML = isHTML
        t.isDebugModeEnabled = debug
        t.isMeasurePerformanceEnabled = measurePerformance
        
        return t.typographize()
    }
    
    public func typographized(language: String, isHTML: Bool = false, debug: Bool = false, measurePerformance: Bool = false) -> String {
        let locale = NSLocale(localeIdentifier: language)
        return typographized(locale: locale, isHTML: isHTML, debug: debug, measurePerformance: measurePerformance)
    }
}
