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

//Debug.addBorderColorsRecursively(rootView!)
Debug.printRecursiveDescription(program.rootViewController.view)

PlaygroundPage.current.liveView = program.rootViewController

