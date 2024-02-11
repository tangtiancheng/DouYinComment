
/*
import SwiftUI
import WidgetKit


@available(iOS 14.0, *)
public enum ClockHandRotationPeriod {
    case custom(TimeInterval)
    case secondHand, hourHand, minuteHand
}

@available(iOS 14.0, *)
public struct ClockHandRotationModifier : ViewModifier {

    let clockPeriod: WidgetKit._ClockHandRotationEffect.Period
    let clockTimezone: TimeZone
    let clockAnchor: UnitPoint
    
    public init(period: ClockHandRotationPeriod, timezone: TimeZone = .current, anchor: UnitPoint = .center) {
        var clockPeriod: WidgetKit._ClockHandRotationEffect.Period = .secondHand
        switch period {
        case .custom(let timeInterval):
            clockPeriod = .custom(timeInterval)
        case .secondHand:
            clockPeriod = .secondHand
        case .hourHand:
            clockPeriod = .hourHand
        case .minuteHand:
            clockPeriod = .minuteHand
        }
        self.clockPeriod = clockPeriod
        self.clockTimezone = timezone
        self.clockAnchor = anchor
    }

    public func body(content: Content) -> some View {
        content
            ._clockHandRotationEffect(self.clockPeriod, in: self.clockTimezone, anchor: self.clockAnchor)
    }

}

@available(iOS 14.0, *)
extension View {

    public func clockHandRotationEffect(period : ClockHandRotationPeriod, in timeZone: TimeZone = .current, anchor: UnitPoint = .center) -> some View {
        return modifier(ClockHandRotationModifier(period: period, timezone: timeZone, anchor: anchor))

        
    }
    
   
}


*/
