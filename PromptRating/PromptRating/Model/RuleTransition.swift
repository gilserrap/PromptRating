
import Foundation

private struct PropertyKey {
    static let firstResult = "firstResult"
    static let secondResult = "secondResult"
    static let conditions = "conditions"
}

open class RuleTransition: NSObject, NSCoding {
    
    let result: PromptResult
    let conditions: [PromptCondition]
    
    init(result: PromptResult, conditions: [PromptCondition]) {
        self.result = result
        self.conditions = conditions
    }
    
    //MARK: NSObject
    
    open override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? RuleTransition {
            return otherObject.result == self.result &&
                otherObject.conditions == self.conditions
        }
        return false
    }
    
    //MARK: NSCoding
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(result.0.rawValue, forKey: PropertyKey.firstResult)
        aCoder.encode(result.1.rawValue, forKey: PropertyKey.secondResult)
        aCoder.encode(conditions, forKey: PropertyKey.conditions)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let firstResult = aDecoder.decodeObject(forKey: PropertyKey.firstResult) as! String
        let secondResult = aDecoder.decodeObject(forKey: PropertyKey.secondResult) as! String
        let conditions = aDecoder.decodeObject(forKey: PropertyKey.conditions) as! [PromptCondition]
        
        
        self.init(
            result: (PromptResultState(rawValue: firstResult)!, PromptResultState(rawValue: secondResult)!),
            conditions: conditions
        )
    }
}
