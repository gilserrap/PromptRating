
import Foundation

public typealias Condition = (Int, PromptEvent)

open class PromptRule: NSObject, NSCoding {
    
    fileprivate let mainEvent: PromptEvent
    fileprivate var conditions = [PromptCondition]()
    fileprivate var ruleTransitions = [RuleTransition]()
    
    public init(forEvent event: PromptEvent) {
        mainEvent = event
    }
    
    public init(mainEvent: PromptEvent, conditions: [PromptCondition], ruleTransitions: [RuleTransition]) {
        self.mainEvent = mainEvent
        self.conditions = conditions
        self.ruleTransitions = ruleTransitions
    }
    
    open func showForTheFirstTimeAfter(_ conditions: Condition...) -> PromptRule {
        
        self.conditions = mapConditionsToPromptConditions(conditions)
        return self
    }
    
    open func whenPromptRatingIs(_ result: PromptResult, showAfter conditions: Condition...) -> PromptRule {
        
        ruleTransitions.append(RuleTransition(result: result, conditions: mapConditionsToPromptConditions(conditions)))
        
        return self
    }
    
    internal func changeConditionsFor(_ promptResult: PromptResult) -> Bool {
        
        guard let transition = ruleTransitions.filter({ $0.result == promptResult }).first else { return false }
        
        conditions = transition.conditions
        
        return true
    }
    
    internal func addEvents(_ events: [PromptEvent]) {
        
        for condition in conditions {
            condition.eventCount = events.reduce(condition.eventCount) { (eventCount, event) -> Int in
                if condition.event == event {
                    return eventCount + 1
                }
                return eventCount
            }
        }
    }
    
    internal func eventIsRelevant(_ event: PromptEvent) -> Bool {
        
        return conditions.filter { $0.event == event }.count > 0 || event == mainEvent
    }
    
    internal func resetEvents() {
        for condition in conditions {
            condition.eventCount = 0
        }
    }
    
    internal func isSatisfied() -> Bool {
        
        for condition in conditions {
            if !condition.isSatisfied() {
                return false
            }
        }
        return true
    }
    
    internal func isTriggeredByEvent(_ event: PromptEvent) -> Bool {
        return event == mainEvent
    }
    
    fileprivate func mapConditionsToPromptConditions(_ conditions: [Condition]) -> [PromptCondition] {
        return conditions.map { condition -> PromptCondition in
            return PromptCondition(
                event: condition.1,
                threshold: condition.0,
                eventCount: 0
            )
        }
    }
    
    //MARK: NSObject
    
    open override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? PromptRule {
            return otherObject.ruleTransitions == self.ruleTransitions &&
                   otherObject.mainEvent.value() == self.mainEvent.value()
        }
        return false
    }
    
    
    open override var description: String {
        return self.mainEvent.value()
    }
    
    //MARK: NSCoding
    
    struct PropertyKey {
        static let mainEvent = "mainEvent"
        static let conditions = "conditions"
        static let transitions = "transitions"
    }
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(mainEvent.value(), forKey: PropertyKey.mainEvent)
        aCoder.encode(conditions, forKey: PropertyKey.conditions)
        aCoder.encode(ruleTransitions, forKey: PropertyKey.transitions)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mainEvent = PromptRatingEvent(name: aDecoder.decodeObject(forKey: PropertyKey.mainEvent) as! String)
        let conditions = aDecoder.decodeObject(forKey: PropertyKey.conditions) as! [PromptCondition]
        let ruleTransitions = aDecoder.decodeObject(forKey: PropertyKey.transitions) as! [RuleTransition]
        
        self.init(mainEvent: mainEvent, conditions: conditions, ruleTransitions: ruleTransitions)
    }
}
