//
//  TypographizerTests.swift
//  TypographizerTests
//
//  Created by Vincent Esche on 2017-05-18.
//  Copyright © 2017 Frank Rausch. All rights reserved.
//

import XCTest

@testable import Typographizer

class TypographizerTests: XCTestCase {

    let string = "The 'quick' brown fox jumps over the \"lazy\" dog."

    func testTypographized_he() {
        let expected = "The \'quick\' brown fox jumps over the \"lazy\" dog."
        XCTAssertEqual(self.string.typographized(language: "he"), expected)
    }

    func testTypographized_cs_da_de_et_is_lt_lv_sk_sl() {
        let expected = "The ‚quick‘ brown fox jumps over the „lazy“ dog."
        XCTAssertEqual(self.string.typographized(language: "cs"), expected)
        XCTAssertEqual(self.string.typographized(language: "da"), expected)
        XCTAssertEqual(self.string.typographized(language: "de"), expected)
        XCTAssertEqual(self.string.typographized(language: "et"), expected)
        XCTAssertEqual(self.string.typographized(language: "is"), expected)
        XCTAssertEqual(self.string.typographized(language: "lt"), expected)
        XCTAssertEqual(self.string.typographized(language: "lv"), expected)
        XCTAssertEqual(self.string.typographized(language: "sk"), expected)
        XCTAssertEqual(self.string.typographized(language: "sl"), expected)
    }

    func testTypographized_de_CH() {
        let expected = "The ‹quick› brown fox jumps over the «lazy» dog."
        XCTAssertEqual(self.string.typographized(language: "de_CH"), expected)
    }

    func testTypographized_bs_fi_sv() {
        let expected = "The ’quick’ brown fox jumps over the ”lazy” dog."
        XCTAssertEqual(self.string.typographized(language: "bs"), expected)
        XCTAssertEqual(self.string.typographized(language: "fi"), expected)
        XCTAssertEqual(self.string.typographized(language: "sv"), expected)
    }

    func testTypographized_fr() {
        let expected = "The ‹ quick › brown fox jumps over the « lazy » dog."
        XCTAssertEqual(self.string.typographized(language: "fr"), expected)
    }

    func testTypographized_hu_pl_ro() {
        let expected = "The ’quick’ brown fox jumps over the „lazy” dog."
        XCTAssertEqual(self.string.typographized(language: "hu"), expected)
        XCTAssertEqual(self.string.typographized(language: "pl"), expected)
        XCTAssertEqual(self.string.typographized(language: "ro"), expected)
    }

    func testTypographized_ja() {
        let expected = "The 『quick』 brown fox jumps over the 「lazy」 dog."
        XCTAssertEqual(self.string.typographized(language: "ja"), expected)
    }

    func testTypographized_ru_no_nn() {
        let expected = "The ’quick’ brown fox jumps over the «lazy» dog."

        XCTAssertEqual(self.string.typographized(language: "ru"), expected)
        XCTAssertEqual(self.string.typographized(language: "no"), expected)
        XCTAssertEqual(self.string.typographized(language: "nn"), expected)
    }

    func testTypographized_en_nl() {
        let expected = "The ‘quick’ brown fox jumps over the “lazy” dog."
        XCTAssertEqual(self.string.typographized(language: "en"), expected)
        XCTAssertEqual(self.string.typographized(language: "nl"), expected)
    }

    func testApostrophe() {
        XCTAssertEqual("John's.".typographized(language: "en"), "John’s.")
    }

    func testPerformanceExample() {
        let string = Array(repeating: self.string, count: 1000).joined(separator: " ")
        self.measure {
            let _ = string.typographized(language: "en")
        }
    }
}
