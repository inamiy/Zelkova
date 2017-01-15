#if os(macOS)

// TODO: Not tested yet.

import AppKit

extension NSControl
{
    public func addHandler(_ handler: @escaping (NSControl) -> ())
    {
        let target = self.zelkova.associatedValue { _ in CocoaTarget<NSControl>(handler) { $0 as! NSControl } }

        self.target = target
        self.action = #selector(target.sendNext)
    }

    public func removeHandler()
    {
        self.target = nil
        self.action = nil
    }
}

#endif
