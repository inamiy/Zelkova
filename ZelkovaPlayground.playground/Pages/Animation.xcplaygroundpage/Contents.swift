import UIKit
import PlaygroundSupport
import LayoutKit
import Zelkova

let rootSize = CGSize(width: 320, height: 480)

enum Msg: Message
{
    case toggle(UserInterfaceLayoutDirection)

    var animationStyle: AnimationStyle
    {
        switch self {
            case let .toggle(direction):
                let context = BasicAnimationContext(timeInterval: 0.3, direction: direction)
                return AnimationStyle.basic(context)
        }
    }
}

typealias Model = Bool

func update(model: Model, msg: Msg) -> Model?
{
    switch msg {
        case .toggle:
            return !model
    }
}

/// Animation example from LayoutKit.
/// - SeeAlso: https://github.com/linkedin/LayoutKit/blob/master/docs/animations.md
func view(_ model: Model, send: @escaping (Msg) -> ()) -> SizeLayout<UIView>
{
    // The initial layout.
    let before = InsetLayout(
        inset: 30,
        sublayout: StackLayout(
            axis: .vertical,
            distribution: .fillEqualSpacing,
            sublayouts: [
                SizeLayout<UIView>(
                    width: 100,
                    height: 100,
                    alignment: .topLeading,
                    viewReuseId: "bigSquare",
                    sublayout: SizeLayout<UIView>(
                        width: 10,
                        height: 10,
                        alignment: .bottomTrailing,
                        viewReuseId: "redSquare",
                        config: { view in
                            view.backgroundColor = UIColor.red
                        }
                    ),
                    config: { view in
                        view.backgroundColor = UIColor.gray
                    }
                ),
                SizeLayout<UIView>(
                    width: 80,
                    height: 80,
                    alignment: .bottomTrailing,
                    viewReuseId: "littleSquare",
                    config: { view in
                        view.backgroundColor = UIColor.lightGray
                    }
                )
            ]
        )
    )

    // The final layout.
    let after = InsetLayout(
        inset: 30,
        sublayout: StackLayout(
            axis: .vertical,
            distribution: .fillEqualSpacing,
            sublayouts: [
                SizeLayout<UIView>(
                    width: 100,
                    height: 100,
                    alignment: .topLeading,
                    viewReuseId: "bigSquare",
                    config: { view in
                        view.backgroundColor = UIColor.gray
                    }
                ),
                SizeLayout<UIView>(
                    width: 50,
                    height: 50,
                    alignment: .bottomTrailing,
                    viewReuseId: "littleSquare",
                    sublayout: SizeLayout<UIView>(
                        width: 20,
                        height: 20,
                        alignment: .topLeading,
                        viewReuseId: "redSquare",
                        config: { view in
                            view.backgroundColor = UIColor.red
                        }
                    ),
                    config: { view in
                        view.backgroundColor = UIColor.lightGray
                    }
                )
            ]
        )
    )

    func button(key: String, title: String, msg: Msg, config: @escaping (UIButton) -> ()) -> ButtonLayout<UIButton>
    {
        return ButtonLayout<UIButton>(
            type: .custom,
            title: title,
            font: .systemFont(ofSize: 24),
            contentEdgeInsets: EdgeInsets(top: 10, left: 50, bottom: 10, right: 50),
            alignment: .center,
            viewReuseId: key,
            config: {
                config($0)
                $0.setTitleColor(.white, for: .normal)
                $0.zelkova.addHandler(for: .touchUpInside) { _ in
                    send(msg)
                }
            }
        )
    }

    func stack() -> StackLayout<UIView>
    {
        return StackLayout<UIView>(
            axis: .vertical,
            spacing: 40,
            alignment: .center,
            viewReuseId: "Before & After Stack",
            sublayouts: [
                SizeLayout<UIView>(
                    width: rootSize.width,
                    viewReuseId: "Before & After",
                    sublayout: model ? after : before
                ),
                button(key: "toggle", title: "Toggle", msg: .toggle(model ? .leftToRight : .rightToLeft)) {
                    $0.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                }
            ],
            config: { _ in }
        )
    }

    return SizeLayout<UIView>(
        size: rootSize,
        viewReuseId: "Root",
        sublayout: stack(),
        config: {
            $0.backgroundColor = .white
        }
    )
}

let program = Program(model: false, update: update, view: view)

let rootView = program.rootViewController.view
rootView?.bounds.size = rootSize

//Debug.addBorderColorsRecursively(rootView!)
Debug.printRecursiveDescription(program.rootViewController.view)

PlaygroundPage.current.liveView = rootView

