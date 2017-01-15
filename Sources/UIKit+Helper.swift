#if os(iOS) || os(tvOS)

import UIKit

extension ZelkovaPrefix where Base: UIControl
{
    internal typealias ControlTargets = [UIControlEvents: CocoaTarget<UIControl>]

    /// `CocoaTarget` storage that has a reference type.
    internal var controlTargets: MutableBox<ControlTargets>
    {
        return self.associatedValue { _ in MutableBox<ControlTargets>([:]) }
    }

    public func addHandler(for controlEvents: UIControlEvents, handler: @escaping (UIControl) -> ())
    {
        if self.controlTargets.value[controlEvents] != nil {
            self.removeHandler(for: controlEvents)
        }

        self.controlTargets.value[controlEvents] = CocoaTarget<UIControl>(handler) { $0 as! UIControl }

        let target = self.controlTargets.value[controlEvents]!

        self.base.addTarget(target, action: #selector(target.sendNext), for: controlEvents)
    }

    public func removeHandler(for controlEvents: UIControlEvents)
    {
        if let target = self.controlTargets.value[controlEvents] {
            self.base.removeTarget(target, action: #selector(target.sendNext), for: controlEvents)

            self.controlTargets.value[controlEvents] = nil
        }
    }
}

// MARK: UIControlEvents + Hashable

// NOTE: Required for -Owhole-module-optimization... (bug?)
extension UIControlEvents: Equatable
{
    public static func == (lhs: UIControlEvents, rhs: UIControlEvents) -> Bool
    {
        return lhs.rawValue == rhs.rawValue
    }
}

extension UIControlEvents: Hashable
{
    public var hashValue: Int
    {
        return Int(self.rawValue)
    }
}

#endif
