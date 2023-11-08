# Browser

## Browser Extensions

uBlock Origin, Vimium, Tampermonkey, Google Translate, Dark Reader, Wappalyzer, Bitwarden, I don't care about cookies

## Vimium Options

### Excluded URLs and keys

| Patterns                        | Keys  |
| ------------------------------- | ----- |
| https?://www.youtube.com/watch* | f < > |

### Custom key mappings

```
unmap /
map / focusInput

map <c-/> enterFindMode
```

### Miscellaneous options

\+ Ignore keyboard layout

## Tampermonkey

### Google Translate

```JavaScript
// ==UserScript==
// @name         Google Translate press listen button
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://translate.google.com/*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    //function sleep(ms) {return new Promise(resolve => setTimeout(resolve, ms))} // timeout function to be set later
    window.addEventListener("keydown", pressKey, false)
    async function pressKey(key) {
        // let box = document.querySelector('.er8xn') // select text area
        const button = document.querySelector('[jsname="UsVyAb"]')
        // if (key.key == 'q' && key.ctrlKey || key.key == 'й' && key.ctrlKey) { // if 'q' and 'ctrl' keypress
        if (key.key == 'u' && key.metaKey || key.key == 'г' && key.metaKey) {
            button.click()
            //await sleep(500)
            //box.focus()
            //box.select()
            //alert("Greetings my friend! Good Work! ")
        }
    }
})();
```

### Google Search input Home/End buttons focus

```JavaScript
// ==UserScript==
// @name         Google Search input Home/End button functionality
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.google.com/search*
// @icon         https://www.google.com/s2/favicons?sz=64&domain=google.com
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const textarea = document.querySelector('textarea[name="q"]')
    textarea.addEventListener("keydown", functionX, false)
    function functionX (e){
        if (e.key === 'Home') {
            //textarea.dispatchEvent(new KeyboardEvent('keydown', {'key': 'a'}));
            e.preventDefault()
            textarea.setSelectionRange(0, 0);
            textarea.focus();
        }
         if (e.key === 'End') {
            //textarea.dispatchEvent(new KeyboardEvent('keydown', {'key': 'a'}));
            e.preventDefault()
            textarea.setSelectionRange(-1, -1);
            textarea.focus();
        }
    }

})();
```
