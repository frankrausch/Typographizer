<img src="https://raw.githubusercontent.com/frankrausch/typographizer/master/logo.png" width="90" height="90">

## Typographizer · Smart Quotes for Swift Apps

Typographizer turns those pesky dumb quotes (`""`/`''`) and apostrophes (`'`) into their beautiful, curly, localized counterparts. Because [good typography uses smart quotes, not dumb quotes](http://smartquotesforsmartpeople.com/) and we should not let [the internet kill smart quotes](https://www.theatlantic.com/technology/archive/2016/12/quotation-mark-wars/511766/). Speaking of smartness: Typographizer is smart enough to skip HTML tags and everything between certain tags (like `<code>` and `<pre>`).

Typographizer has a small footprint, was written in pure Swift 3, and has been tested on macOS, iOS, watchOS, and tvOS.

I started building Typographizer to typographize Wikipedia articles in my [V&nbsp;for&nbsp;Wiki](http://v-for-wiki.com) app.

## Installation

Put the `.swift` files into your app’s Xcode project.

## How to Use

The easiest way to use Typographizer is the String extension (`String+Typographizer.swift`):

```swift
var s = "This is a string with \"dumb\" quotes."

s = s.typographized(language: "en")

print(s) // This is a string with “dumb” quotes.
```

### Ignoring HTML Tags

If your string may contain HTML, set the `isHTML` parameter to `true`. Typographizer will then ignore the quotes inside tags and anything between `<pre>`, `<code>`, `<var>`, `<samp>`, `<kbd>`, `<math>`, `<script>`, and `<style>` tags:

```swift
var s = "This is a \"string\" with HTML. <code class="">print(\"hello world\")</code>"

s = s.typographized(language: "en", isHTML: true)

print(s) // This is a “string” with HTML. <code class="">print("hello world")</code>
```

### Debug Mode

Activate the debug mode to highlight the characters that have been changed—Typographizer will add this tag around them: `<span class="typographizer-debug typographizer-debug--XXX">` `</span>`

```swift
var s = "This is a string with \"dumb\" quotes."

s = s.typographized(language: "en", isHTML: true, debug: true)

print(s) // This is a string with <span class="typographizer-debug typographizer-debug--opening-double">“</span>dumb<span class="typographizer-debug typographizer-debug--closing-double">”</span> quotes.
```

(Yes, the class names are a little wordy, but that’s [on purpose](https://csswizardry.com/2013/01/mindbemding-getting-your-head-round-bem-syntax/).)

Use CSS to visualize the changes:

```css
.typographizer-debug {
  font-weight: bold;
}

.typographizer-debug--apostrophe {
  color: red;
}

/* … */
```

### Measuring Performance

Pass `measurePerformance: true` to log performance stats:

```swift
s = s.typographized(language: "en", isHTML: true, debug: false, measurePerformance: true)
```

You’ll see something like this in the Xcode console:

```
Typographizing took 0.00582303 seconds
```

## Features

- [x] Fixes double quotes: `""` → `“”` (localized)
- [x] Fixes single quotes: `''` → `‘’` (localized)
- [x] Fixes apostrophes: `'` → `’`
- [x] Fixes hyphens that are used as en dashes: `… - …` → `… – …`
- [x] Demo app project for macOS

## Supported Languages

| Language Code | Double Quotes | Single Quotes | Comment |
| :---: | :---: | :---: | --- |
| `bs` | `”` `”` | `’` `’` | |
| `cs` | `„` `“` | `‚` `‘` | |
| `da` | `„` `“` | `‚` `‘` | |
| `de` | `„` `“` | `‚` `‘` | |
| `de_CH` | `«` `»` | `‹` `›` | Swiss German |
| `en` | `“` `”` | `‘` `’` | |
| `et` | `„` `“` | `‚` `‘` | |
| `fi` | `”` `”` | `’` `’` | |
| `fr` | `«\u{00A0}` `\u{00A0}»` | `‹\u{00A0}` `\u{00A0}›` | French Quotes are set with a non-breaking space (`\u{00A0}`). A thin non-breaking space would be better, but it’s not supported in most browsers.|
| `hu` | `„` `”` | `’` `’` | |
| `is` | `„` `“` | `‚` `‘` | |
| `ja` | `「` `」` |`『` `』`  | |
| `lt` | `„` `“` | `‚` `‘` | |
| `lv` | `„` `“` | `‚` `‘` | |
| `nl` | `“` `”` | `‘` `’` | |
| `nn` | `«` `»` | `’` `’` | |
| `no` | `«` `»` | `’` `’` | |
| `pl` | `„` `”` | `’` `’` | |
| `ro` | `„` `”` | `’` `’` | |
| `ru` | `«` `»` | `’` `’` | |
| `sk` | `„` `“` | `‚` `‘` | |
| `sl` | `„` `“` | `‚` `‘` | |
| `sv` | `”` `”` | `’` `’` | |

## Demo App
To get started, try the included demo app for macOS.

![](https://cloud.githubusercontent.com/assets/6783714/24149232/0b818208-0e42-11e7-9257-b2afda792f2b.png "Screenshot of Typographizer Demo App")


## To Do

- [ ] Handle special cases like ’80s, ’Twas, Rock ’n’ Roll, etc.
- [ ] Handle primes in coordinates properly:  
52°&nbsp;27'&nbsp;20"&nbsp;N, 13°&nbsp;19'&nbsp;11"&nbsp;E → 52°&nbsp;27′&nbsp;20″&nbsp;N, 13°&nbsp;19′&nbsp;11″&nbsp;E
- [ ] Add support for Hebrew
- [ ] If there is only one dumb single quote in a string, it’s probably an apostrophe
- [ ] Analyze HTML tags to verify correct quotes (opening and closing `<p>` tags make a good indicator for opening and closing quotation marks)
- [ ] Track open/closed state while iterating over the text to make more informed decisions
- [ ] Add more typographic refinements (e.g. prime symbols, thin spaces)
- [ ] Add Carthage/CocoaPods support (or maybe this is overkill?)

## Credits

Typographizer was created by [Frank Rausch](http://frankrausch.com) ([@frankrausch](https://twitter.com/frankrausch)).

Thanks to Tony Allevato for the great article on [Strings, characters, and performance in Swift—a deep dive](https://medium.com/@tonyallevato/strings-characters-and-performance-in-swift-a-deep-dive-b7b5bde58d53).

## License
The Typographizer source code is released under the MIT License. Please view the LICENSE file for details.

The Typographizer logo is © 2017 Frank Rausch; all rights reserved.
