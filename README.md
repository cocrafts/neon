[neon-link]: https://neon.metacraft.studio/
[react-native-link]: https://reactnative.dev/

**[Website][neon-link] • [API Docs](https://neon.metacraft.studio/docs) • [Features Tutorial](https://neon.metacraft.studio/tutorials) • [Playground](https://neon.metacraft.studio/playground) • [Discord](https://discord.gg/3NJAjgDnbG)**

[Neon][neon-link] is a library for creating cross-platform user interfaces that run everywhere on native runtime!

### [Neon][neon-link] unique characteristics:
- Run directly on native runtime, no intermediate/embedded runtime - which allow [Neon][neon-link] easily target devices like: `IoT`, `smartWatch` where embedded runtime e.g Javascript is too expensive to afford.
- Instead of using a `Virtual DOM` or Runtime Diffing, [Neon][neon-link] generate/optimize its templates at Compile Time (like [Svelte](https://svelte.dev/)) and updates them with fine-grained reactions (like [SolidJS](https://www.solidjs.com/)) for the best performance.
- [Neon][neon-link] use [Haxe](https://haxe.org/) language/syntax - part of [ECMAScript](https://ecma-international.org/publications-and-standards/standards/ecma-262/) family, Javascript developer would find it extremely familiar, like home.

## At a Glance:
```haxe
package myApp;

import js.Browser.document;
import neon.platform.browser.Renderer;
import neon.core.Common;
import neon.core.Style;
import neon.core.State;

class Main {
    public static function main() {
        render(document.body, App, {name: "My App"});
    }
}

typedef AppProps = {
    var name:String;
};

var App = createComponent(function(props:AppProps) {
    var count = createSignal(0);
    var doubleCount = function() {
        return count.get() * 2;
    }

    var handleClick = function() {
        count.set(count.get() + 1);
    }

    return createElement("div", {style: styles.container}, [
        createElement("h1", {}, [
            "welcome ", props.name,
        ]),
        createElement("h2", {click: handleClick}, [
            "counter is: ", count.get(),
        ]),
        createElement("h2", {}, [
            "doubleCount is: ", doubleCount(),
        ]),
    ]);
});

var styles = createStyle({
    container: {
        color: "red",
        userSelect: "none",
        "@media (max-width: 768px)": {
            color: "green",
        }
    },
});
```

### Platform support status:
- [x] Browser
- [x] Server side rendering, including `Node.js` (good for portable runtime like AWS Lambda Edge), and also include `C++` target (offer blazing fast performance)
- [ ] iOS
- [ ] Android
- [ ] watchOS
- [ ] wearOS
- [ ] macOS
- [ ] Windows
- [ ] Linux
- [ ] Other targets like VR/AR, smartTv, IoT devices..

