
import Foundation

public protocol PromptEvent {
    
    func value() -> String
}

internal struct PromptRatingEvent: PromptEvent {
    
    let name: String
    
    func value() -> String {
        return name
    }
}

public func ==(lhs: PromptEvent, rhs: PromptEvent) -> Bool {
    return lhs.value() == rhs.value()
}
