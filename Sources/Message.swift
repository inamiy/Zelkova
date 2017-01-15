/// Message protocol that also defines animation style.
public protocol Message
{
    var animationStyle: AnimationStyle { get }
}

extension Message
{
    // Default implementation.
    public var animationStyle: AnimationStyle
    {
        return .none
    }
}
