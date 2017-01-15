import UIKit
import Result
import ReactiveSwift
import ReactiveAutomaton
import LayoutKit

/// Wrapper of `LayoutKit`, `Automaton`, and Reactive renderer.
public final class Program<Model, Msg: Message>
{
    /// Mixture of Elm's `Task`, `Cmd`, `Sub`.
    public typealias Effect = SignalProducer<Msg, NoError>

    public typealias Send = (Msg) -> ()

    private typealias _Automaton = ReactiveAutomaton.Automaton<Model, Msg>

    public let rootViewController = UIViewController()

    private let _diffScheduler = QueueScheduler(qos: .userInteractive, name: "com.inamiy.Zelkova.diffScheduler")

    private let _automaton: _Automaton
    private let _rootView: Property<UIView?>

    /// Beginner Program.
    public convenience init<L: Layout>(model: Model, update: @escaping _Automaton.Mapping, view: @escaping (Model, @escaping Send) -> L)
    {
        self.init(initial: (model, .empty), update: _compose(_toNextMapping, update), view: view)
    }

    /// Non-beginner Program.
    public init<L: Layout>(initial: (Model, Effect), update: @escaping _Automaton.NextMapping, view: @escaping (Model, @escaping Send) -> L)
    {
        let (inputSignal, inputObserver) = Signal<Msg, NoError>.pipe()

        let initialState = initial.0
        self._automaton = Automaton(state: initialState, input: inputSignal, mapping: update)

        let rootView = self.rootViewController.view
        self._rootView = Property(value: rootView)

        let initialLayout = view(initialState, inputObserver.send(value:))
        initialLayout.arrangement().makeViews(in: rootView)

        self._automaton.replies
            .observe(on: self._diffScheduler)
            .withLatest(from: self._rootView.producer)
            .flatMap(.merge) { reply, rootView -> SignalProducer<(Msg, UIView, LayoutArrangement), NoError> in
                guard let rootView = rootView, let newState = reply.toState else {
                    return .empty
                }
                let newLayout = view(newState, inputObserver.send(value:))
                let arrangement = newLayout.arrangement()
                return .init(value: (reply.input, rootView, arrangement))
            }
            .observe(on: QueueScheduler.main)
            .observeValues { msg, rootView, arrangement in

                switch msg.animationStyle {
                    case let .basic(context):
                        let animation = arrangement.prepareAnimation(for: rootView, direction: context.direction)

                        UIView.animate(
                            withDuration: context.timeInterval,
                            animations: {
                                animation.apply()
                            }
                        )

                    default:
                        arrangement.makeViews(in: rootView)
                }
            }

        let initialEffect = initial.1
        initialEffect.startWithValues { msg in
            inputObserver.send(value: msg)
        }
    }
}

// MARK: Private

private func _compose<A, B, C>(_ g: @escaping (B) -> C, _ f: @escaping (A) -> B) -> (A) -> C
{
    return { x in g(f(x)) }
}

private func _toNextMapping<State, Input>(_ toState: State?) -> (State, SignalProducer<Input, NoError>)?
{
    if let toState = toState {
        return (toState, .empty)
    }
    else {
        return nil
    }
}
