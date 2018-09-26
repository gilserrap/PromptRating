
import Foundation

public enum DefaultEvents: String, PromptEvent {
    
    case MinorVersionIncreased = "MinorVersionIncreased"
    case Session = "Session"
    case Month = "Month"
    
    public func value() -> String {
        return rawValue
    }
}

public enum PromptResultState: String {
    
    case Positive = "Positive"
    case Negative = "Negative"
}

public typealias PromptResult = (PromptResultState, PromptResultState)

public typealias PromptResultCallback = (PromptResult) -> ()
public typealias RuleTriggeredCallback = (PromptRule, @escaping PromptResultCallback) -> ()

open class PromptRating {
    
    fileprivate var rulesStore: PromptRatingDataStore?
    fileprivate var rules = [PromptRule]()
    
    fileprivate var eventTrackers = [PromptGlobalEventTracker]()
    
    public init() {
        subscribeToApplicationEvents()
    }

    public init(rulesStore: PromptRatingDataStore) {
        self.rulesStore = rulesStore
        loadPreviousState()
        subscribeToApplicationEvents()
    }
    
    open func setRules(_ validRules: [PromptRule]) {
        
        rules = rules.filter { currentRule in
            return validRules.contains(currentRule)
        }
        
        for rule in validRules {
            if !rules.contains(rule) {
                rules.append(rule)
            }
        }
    }
    
    open func setEventTrackers(_ eventTrackers: [PromptGlobalEventTracker]) {
        
        self.eventTrackers = eventTrackers
    }
    
    open func addEvents(_ events: [PromptEvent]) {
        
        for rule in rules {
            
            let relevantEvents = events.filter { rule.eventIsRelevant($0) }
            rule.addEvents(relevantEvents)
        }
    }
    
    open func addEvent(_ event: PromptEvent, handlePromptRating: @escaping RuleTriggeredCallback) {
        
        for rule in rules {
            
            if rule.eventIsRelevant(event) {
                rule.addEvents([event])
            }
            if rule.isTriggeredByEvent(event) && rule.isSatisfied() {
                
                handlePromptRating(rule) { result in
                    self.resetAllRulesAndChangeConditionsAccordingTo(result)
                }
            }
        }
    }
    
    fileprivate func resetAllRulesAndChangeConditionsAccordingTo(_ promptRatingResult: PromptResult) {
        for rule in rules {
            rule.resetEvents()
            let _ = rule.changeConditionsFor(promptRatingResult)
        }
    }
    
    //MARK: Persistence
    
    open func saveCurrentState() {
        if let rulesStore = rulesStore {
            rulesStore.saveCurentRules(rules)
        }
    }
    
    fileprivate func loadPreviousState() {
        if let storedRules = rulesStore?.getLastSavedRules() {
            rules = storedRules
        }
    }
    
    //MARK: Notifications
    
    fileprivate func subscribeToApplicationEvents() {
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(PromptRating.applicationLaunch(_:)),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(PromptRating.applicationClosed(_:)),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil
        )
    }
    
    fileprivate func unsubscribeFromApplicationEvents() {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc fileprivate func applicationLaunch(_ notification: Notification) {
        addEvents(eventTrackers.flatMap {$0.evaluateOnApplicationLaunched()})
    }
    
    @objc fileprivate func applicationClosed(_ notification: Notification) {
        saveCurrentState()
        addEvents(eventTrackers.flatMap {$0.evaluateOnApplicationClosed()})
    }
}
