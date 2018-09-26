
import Foundation

private struct StorageKeys {
    static let installationDate = "lastApplicationLaunch"
    static let numberOfTrackedMonths = "numberOfTrackedMonths"
}

private struct Month {
    static let timeInterval = 2629743.0
}

public struct MonthEventTracker: PromptGlobalEventTracker {
    
    fileprivate let storage: UserDefaults
    
    public init(storage: UserDefaults) {
        self.storage = storage
    }
    
    public func evaluateOnApplicationLaunched() -> [PromptEvent] {
    
        var events = [PromptEvent]()
        
        guard let installationDate = storage.object(forKey: StorageKeys.installationDate) as? Date else {
            storage.set(Date(), forKey: StorageKeys.installationDate)
            storage.set(0, forKey: StorageKeys.numberOfTrackedMonths)
            storage.synchronize()
            return events
        }
        
        let monthsSinceInstallation = numberOfMonthsBetween(startDate: installationDate, endDate: Date())
        let numberOfTrackedMonths = storage.integer(forKey: StorageKeys.numberOfTrackedMonths)
        
        var untrackedMonths = monthsSinceInstallation - numberOfTrackedMonths
        if untrackedMonths < 0 {
            untrackedMonths = 0
        }
        for _ in 0..<untrackedMonths {
            events.append(DefaultEvents.Month)
        }
        
        storage.set(monthsSinceInstallation, forKey: StorageKeys.numberOfTrackedMonths)
        storage.synchronize()
        
        return events
    }
    
    fileprivate func numberOfMonthsBetween(startDate: Date, endDate: Date) -> Int {
    
        let timeIntervalSinceLastLaunch = Date().timeIntervalSince(startDate)
        let months = Int(fabs(timeIntervalSinceLastLaunch / Month.timeInterval))
        return months
    }
}
