<svg xmlns="http://www.w3.org/2000/svg" width="90" height="90" viewBox="0 0 90 90" alt="Typographizer"><path fill="#0366D6" fill-rule="evenodd" d="M12.56 66.792l26.324-4.569c4.472-.776 6.437-3.616 5.631-7.834l-3.177-16.64c-.847-4.435-3.686-6.354-8.134-5.573l-10.568 1.857-.146-.164c.44-.813 1.186-2.979 1.842-6.04l2.351-10.98c.26-1.658.712-3.154-1.347-3.883l-4.329-1.532c-1.851-.655-3.301-.72-4.574.881L4.885 30.35C.645 36.968.464 39.654 1.587 47.643l1.907 13.563c.635 4.519 3.438 6.563 9.066 5.586zm17.93-12.874c0 1.509-2.717 4.593-6.814 4.593-2.327 0-6.195-1.237-6.195-2.7 0-.668.442-1.322 1.285-1.322 1.089 0 2.583 1.186 5.108 1.186 1.977 0 3.55-.623 4.71-2.047.376-.46.72-.697 1.048-.697.483 0 .859.462.859.987zM68.95 75.566c1.851.655 3.301.72 4.574-.881 4.29-6.774 8.581-13.548 11.518-18.116 4.25-6.611 4.418-9.305 3.297-17.294l-1.904-13.576c-.634-4.52-3.438-6.563-9.067-5.587l-26.324 4.57c-4.471.775-6.436 3.615-5.615 7.83l3.158 16.644c.846 4.436 3.692 6.365 8.126 5.508l7.268-1.23c5.669-.958 9.884-2.729 11.037-7.29.131-.521.613-.716 1.029-.716.638 0 1.3.517 1.3 1.345 0 2.793-3.13 8.077-12.252 9.312l-1.849 13.968c-.232 1.756-.572 2.99 1.375 3.98l4.329 1.533zM58.704 39.625l-.832-.628c-.271-.204-.236-.338-.047-.615l2.138-3.607-2.31.4c-.589.101-.972-.183-1.085-.771l-.334-1.756c-.107-.56.154-.936.747-1.04l3.493-.606c.747-.13 1.12.142 1.204.742l.288 2.058c.113.804.066 1.146-.294 1.746l-2.428 4.046c-.168.212-.33.19-.54.03zm8.987-1.305l-.832-.628c-.271-.204-.236-.338-.047-.615l2.138-3.607-2.309.4c-.59.101-.973-.183-1.085-.771l-.335-1.756c-.107-.56.154-.937.747-1.04l3.494-.606c.747-.13 1.119.142 1.203.742l.289 2.058c.112.803.066 1.146-.294 1.745l-2.428 4.047c-.17.212-.331.189-.54.03zm-40.489.44l.833.628c.27.204.235.338.046.615l-2.137 3.607 2.308-.4c.59-.102.973.182 1.086.771l.335 1.755c.106.56-.154.937-.748 1.04l-3.493.607c-.747.13-1.12-.142-1.203-.742l-.29-2.058c-.112-.804-.065-1.146.295-1.746l2.428-4.046c.169-.212.33-.19.54-.03zm-8.713 1.305l.558.628c.226.254.236.338.047.615l-2.138 3.607 2.31-.4c.589-.101.972.183 1.084.771l.335 1.756c.107.56-.154.936-.747 1.04l-3.494.606c-.746.13-1.119-.142-1.203-.742l-.288-2.058c-.113-.803-.095-1.164.293-1.746l2.702-4.046c.17-.212.366-.227.541-.03z"/></svg>

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
| `de` | `„` `“` | `‚` `‘` | To do: There should be a `de_CH` option for Swiss German with guillemets («»/‹›)|
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


## To Do

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
The Typographizer source code is released under the MIT License. Please view the LICENSE file for details.

The Typographizer logo is © 2017 Frank Rausch; all rights reserved.
