
import Foundation

private struct StorageKeys {
    
    static let lastVersion = "lastVersion"
}

public protocol ApplicationData {

    func version() -> String
}

public struct MinorVersionEventTracker: PromptGlobalEventTracker {
    
    fileprivate let storage: UserDefaults
    fileprivate let appInfo: ApplicationData
    
    public init(storage: UserDefaults, appInfo: ApplicationData) {
        self.storage = storage
        self.appInfo = appInfo
    }
    
    public func evaluateOnApplicationLaunched() -> [PromptEvent] {
        
        let currentVersion = appInfo.version()
        let currentVersionComponents = currentVersion.components(separatedBy: ".")
        
        guard currentVersionComponents.count == 3 else {
            print("Version format not supported, use semantic versioning in order for this tracker to work.")
            return [PromptEvent]()
        }
        
        guard let storedVersion = storage.object(forKey: StorageKeys.lastVersion) as? String else {
            storage.set(currentVersion, forKey: StorageKeys.lastVersion)
            storage.synchronize()
            return [PromptEvent]()
        }
        let storedVersionComponents = storedVersion.components(separatedBy: ".")
        
        var events = [PromptEvent]()
        
        if currentVersionComponents[1] != storedVersionComponents[1] {
            events.append(DefaultEvents.MinorVersionIncreased)
            storage.set(currentVersion, forKey: StorageKeys.lastVersion)
            storage.synchronize()
        }
        
        return events
    }
}
