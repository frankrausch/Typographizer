//
//  String+Typographizer.swift
//  Typographizer
//
//  Created by Frank Rausch on 2017-02-04.
//  Copyright © 2017 Frank Rausch.
//

import Foundation

extension String {
    func typographized(language: String, isHTML: Bool = true, debug: Bool = false) -> String {
        var t = Typographizer(language: language, text: self)
        t.isDebugModeEnabled = debug
        t.isHTML = isHTML
        return t.typographize()
    }
}
