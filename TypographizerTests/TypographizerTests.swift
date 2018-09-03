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

    let string = "The 'quick' brown fox jumps over the \"lazy\" dog's ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."

    func testTypographized_he() {
        let expected = "The \'quick\' brown fox jumps over the \"lazy\" dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "he", isHTML: true), expected)
    }

    func testTypographized_cs_da_de_et_is_lt_lv_sk_sl() {
        let expected = "The ‚quick‘ brown fox jumps over the „lazy“ dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "cs", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "da", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "de", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "et", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "is", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "lt", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "lv", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "sk", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "sl", isHTML: true), expected)
    }

    func testTypographized_de_CH_de_LI() {
        let expected = "The ‹quick› brown fox jumps over the «lazy» dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "de_CH", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "de_LI", isHTML: true), expected)
    }

    func testTypographized_bs_fi_sv() {
        let expected = "The ’quick’ brown fox jumps over the ”lazy” dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "bs", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "fi", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "sv", isHTML: true), expected)
    }

    func testTypographized_fr() {
        let expected = "The ‹ quick › brown fox jumps over the « lazy » dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "fr", isHTML: true), expected)
    }

    func testTypographized_hu_pl_ro() {
        let expected = "The ’quick’ brown fox jumps over the „lazy” dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "hu", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "pl", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "ro", isHTML: true), expected)
    }

    func testTypographized_ja() {
        let expected = "The 『quick』 brown fox jumps over the 「lazy」 dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "ja", isHTML: true), expected)
    }

    func testTypographized_ru_no_nn() {
        let expected = "The ’quick’ brown fox jumps over the «lazy» dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."

        XCTAssertEqual(self.string.typographized(language: "ru", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "no", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "nn", isHTML: true), expected)
    }

    func testTypographized_en_nl() {
        let expected = "The ‘quick’ brown fox jumps over the “lazy” dog’s ear. This is <code style=\"font: 'SF UI'\">\"HTML\"</code>."
        XCTAssertEqual(self.string.typographized(language: "en", isHTML: true), expected)
        XCTAssertEqual(self.string.typographized(language: "nl", isHTML: true), expected)
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
