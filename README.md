## Swift Typographizer

Typographizer turns those pesky dumb quotes `""`/`''` and apostrophes into their beautiful, curly, localized counterparts. Because [good typography uses smart quotes, not dumb quotes](http://smartquotesforsmartpeople.com/) and we should not let [the internet kill smart quotes](https://www.theatlantic.com/technology/archive/2016/12/quotation-mark-wars/511766/). Speaking of smartness: Typographizer is smart enough to skip HTML tags and everything that’s inside certain tags (like `<code>` and `<pre>`).

Typographizer was initially created to typographize Wikipedia articles in the [V&nbsp;for&nbsp;Wiki](http://v-for-wiki.com/) app, a nice reader for iOS and Apple Watch.

Written in Swift 3, it’s been tested on macOS, iOS, and watchOS.

## Installation

Put the `.swift` files into your app’s Xcode project.

## How To Use

The easiest way to use Typographizer is the String extension (`String+Typographizer.swift`):

```swift
var s = "This is a string with \"dumb\" quotes."

s = s.typographized(language: "en")

print(s) // This is a string with “dumb” quotes.
```

If your strings may contain any HTML, set the `isHTML` parameter to `true`:

```swift
var s = "This is a \"string\" with HTML. <code class="">print(\"hello world\")</code>"

s = s.typographized(language: "en", isHTML: true)

print(s) // This is a “string” with HTML. <code class="">print("hello world")</code>
```

Activate the debug mode to highlight the characters that have been changed—Typographizer will add this tag around them: `<span class="typographizerDebug">` `</span>`

```swift
var s = "This is a string with \"dumb\" quotes."

s = s.typographized(language: "en", isHTML: true, debug: true)

print(s) // This is a string with <span class="typographizerDebug">“</span>dumb<span class="typographizerDebug">”</span> quotes.
```

## Features

- [x] Fixes double quotes: `""` → `“”` (localized)
- [x] Fixes single quotes: `''` → `‘’` (localized)
- [x] Fixes apostrophes: `'` → `’`
- [x] Fixes hyphens that are used as en dashes: `… - …` → `… – …`
## Supported Languages

| Language Code | Double Quotes | Single Quotes | Comment |
| --- | --- | --- | --- |
|||
`bs` | ”” | ’’ | |
`cs` | „“ | ‚‘ | |
`da` | „“ | ‚‘ | |
`de` | „“ | ‚‘ | To do: There should be a `de_CH` option for Swiss German with guillemets («»/‹›)|
`en` | “” | ‘’ | |
`et` | „“ | ‚‘ | |
`fi` | ”” | ’’ | |
`fr` | «`\u{00A0}` `\u{00A0}`» | ‹`\u{00A0}` `\u{00A0}`› | French Quotes are set with a non-breaking space (`\u{00A0}`). A thin non-breaking space would be better, but it’s not supported in most browsers.|
`hu` | „” | ’’ | |
`is` | „“ | ‚‘ | |
`ja` | 「」 | 『』 | |
`lt` | „“ | ‚‘ | |
`lv` | „“ | ‚‘ | |
`nl` | “” | ‘’ | |
`nn` | «» | ’’ | |
`no` | «» | ’’ | |
`pl` | „” | ’’ | |
`ro` | „” | ’’ | |
`ru` | «» | ’’ | |
`sk` | „“ | ‚‘ | |
`sl` | „“ | ‚‘ | |
`sv` | ”” | ’’ | |


## To Do

- [ ] Add a demo app project for macOS
- [ ] Build a Swift Framework project (or maybe this is overkill?)
- [ ] Add Carthage/CocoaPods support (or maybe this is overkill?)
- [ ] Analyze HTML tags to verify correct quotes (opening and closing `<p>` tags make a good indicator for opening and closing quotation marks)
- [ ] Add special cases like ’80s, ’Twas, Rock ’n’ Roll, etc.
- [ ] Add support for Hebrew and Swiss German
- [ ] If there is only one dumb single quote in a string, it’s definitely an apostrophe
- [ ] If the isHTML flag is not explicitly set, we could still check automatically whether the string contains any HTML tags
- [ ] Add more typographic refinements (e.g. prime symbols, thin spaces)

## Credits

Typographizer was created by [Frank Rausch](http://frankrausch.com) ([@frankrausch](https://twitter.com/frankrausch)).

Thanks to Tony Allevato for the great article on [Strings, characters, and performance in Swift—a deep dive](https://medium.com/@tonyallevato/strings-characters-and-performance-in-swift-a-deep-dive-b7b5bde58d53).

## License
Swift Typographizer is released under the MIT License. Please view the LICENSE file for details.
