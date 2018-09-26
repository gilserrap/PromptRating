
import Foundation

private struct StorageKeys {
    static let lastDateApplicationWasActive = "lastDateApplicationWasActive"
}

private struct SessionParameters {
    static let inactivityTimeBetweenSessions = 1800.0
}

public struct SessionEventTracker: PromptGlobalEventTracker {
    
    fileprivate let storage: UserDefaults
    
    public init(storage: UserDefaults) {
        self.storage = storage
    }
    
    public func evaluateOnApplicationLaunched() -> [PromptEvent] {
        
        var events = [PromptEvent]()
        
        guard let lastStoredDateApplicationWasActive = storage.object(forKey: StorageKeys.lastDateApplicationWasActive) as? Date else {
            return events
        }
        
        let timeIntervalSinceLastDateApplicationWasActive = Date().timeIntervalSince(lastStoredDateApplicationWasActive)
        
        if timeIntervalSinceLastDateApplicationWasActive > SessionParameters.inactivityTimeBetweenSessions {
            events.append(DefaultEvents.Session)
            storage.synchronize()
        }
        
        return events
    }
    
    public func evaluateOnApplicationClosed() -> [PromptEvent] {
        
        storage.set(Date(), forKey: StorageKeys.lastDateApplicationWasActive)
        return [PromptEvent]()
    }
}
