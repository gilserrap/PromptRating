
import Foundation

public protocol PromptGlobalEventTracker {

    func evaluateOnApplicationLaunched() -> [PromptEvent]
    func evaluateOnApplicationClosed() -> [PromptEvent]
}

public extension PromptGlobalEventTracker {
    
    func evaluateOnApplicationLaunched() -> [PromptEvent] {
        return [PromptEvent]()
    }
    func evaluateOnApplicationClosed() -> [PromptEvent] {
        return [PromptEvent]()
    }
}
