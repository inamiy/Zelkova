import LayoutKit

/// Animation style associated with `Message` to let `Program` handle it.
public enum AnimationStyle
{
    case basic(BasicAnimationContext)
    // TODO:
//    case keyframe(timeInterval: TimeInterval, effect: ((UIView) -> ())?)
//    case spring(timeInterval: TimeInterval, effect: ((UIView) -> ())?)
    case none
}

/// Arguments for basic `UIView.animate(...)`.
public struct BasicAnimationContext
{
    public let timeInterval: TimeInterval
    public let direction: UserInterfaceLayoutDirection

    public init(timeInterval: TimeInterval, direction: UserInterfaceLayoutDirection)
    {
        self.timeInterval = timeInterval
        self.direction = direction
    }
}
