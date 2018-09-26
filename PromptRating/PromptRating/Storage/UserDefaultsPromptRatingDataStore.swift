
import Foundation

open class UserDefaultsPromptRatingDataStore: PromptRatingDataStore {
    
    fileprivate struct StorageKey {
        static let rules = "rules"
    }
    
    let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    open func saveCurentRules(_ currentRules: [PromptRule]) {
        
        let data = NSKeyedArchiver.archivedData(withRootObject: currentRules)
        
        userDefaults.set(data, forKey: StorageKey.rules)
        userDefaults.synchronize()
    }
    
    open func getLastSavedRules() -> [PromptRule] {
    
        if let storedRulesData = userDefaults.object(forKey: StorageKey.rules) as? Data,
            let storedRules = NSKeyedUnarchiver.unarchiveObject(with: storedRulesData) as? [PromptRule]
        {
            return storedRules
        } else {
            return [PromptRule]()
        }
    }
    
    open func reset() {
        
        userDefaults.removeObject(forKey: StorageKey.rules)
        userDefaults.synchronize()
    }
}
