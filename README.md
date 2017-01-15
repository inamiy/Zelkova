# Zelkova

[Elm](http://elm-lang.org)/[React.js](https://github.com/facebook/react)-like architecture in Swift, powered by [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) and [LayoutKit](https://github.com/linkedin/LayoutKit).

> **Zelkova** is a genus of six species of deciduous trees in the **elm family** Ulmaceae ([Wikipedia](https://en.wikipedia.org/wiki/Zelkova)).

Please also check out a sister project: [inamiy/SwiftElm](https://github.com/inamiy/SwiftElm) (if you like black magic ✨🔮✨)

## Example

A simple button tap (increment) example in [ZelkovaPlayground](ZelkovaPlayground.playground).

```swift
import UIKit
import PlaygroundSupport
import LayoutKit
import Zelkova

let rootSize = CGSize(width: 320, height: 480)

enum Msg: Message
{
    case increment
}

typealias Model = Int

func update(model: Model, msg: Msg) -> Model?
{
    switch msg {
        case .increment:
            return model + 1
    }
}

func view(_ model: Model, send: @escaping (Msg) -> ()) -> ButtonLayout<UIButton>
{
    return ButtonLayout<UIButton>(
        type: .custom,
        title: "Tap me! \(model)",
        font: .systemFont(ofSize: 24),
        contentEdgeInsets: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50),
        viewReuseId: "button",
        config: {
            $0.setTitleColor(.white, for: .normal)
            $0.zelkova.addHandler(for: .touchUpInside) { _ in
                send(.increment)
            }
        }
    )
}

let program = Program(model: 0, update: update, view: view)

PlaygroundPage.current.liveView = program.rootViewController
```

Majority of the code comes from [LayoutKit](https://github.com/linkedin/LayoutKit), which works not only as a great layout engine but also as **immutable virtual-view framework** (just like [React.js](https://github.com/facebook/react)).

Please see [ZelkovaPlayground](ZelkovaPlayground.playground) for more examples.

## Terms

Term    | Type                          | Description
------- | ----------------------------- | ------------------------------------------
program | `Program` | State-machine wrapper that manages whole application's states, view rendering, and event delivery.
model   | `Model`   | User-defined application's whole state.
msg     | `Msg`     | User-defined input (event message) that triggers `Program`'s state-machine.
update  | `(model: Model, msg: Msg) -> Model?`     | State-transition function that takes current state and input as arguments, then returns either a new state (transition success) or `nil` (transition failure). 
view    | `(model: Model, send: @escaping (Msg) -> ()) -> LayoutKit.Layout` | View generating/reusing side-effect that creates `LayoutKit.Layout` (virtual-view) from current state. To let views to send a new `Msg` (e.g. button tap), use `send` to add a new side-effect.

## V.S.

- [Few.swift](https://github.com/joshaber/Few.swift)
- [Render](https://github.com/alexdrone/Render)
- [katana-swift](https://github.com/BendingSpoons/katana-swift)
- [inamiy/SwiftElm](https://github.com/inamiy/SwiftElm)

TBD

## Acknowledgement

- Evan Czaplicki: Creator of [Elm](http://elm-lang.org/)
- LinkedIn: Creator of [LayoutKit](https://github.com/linkedin/LayoutKit)

## License

[MIT](LICENSE)
