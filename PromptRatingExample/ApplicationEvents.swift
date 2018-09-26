
import Foundation
import PromptRating

enum Event: String, PromptEvent {
    
    case Session = "Session"
    case ShareOffer = "ShareOffer"
    case Month = "Month"
    case MinorVersion = "MinorVersion"

    func value() -> String {
        return rawValue
    }
}
