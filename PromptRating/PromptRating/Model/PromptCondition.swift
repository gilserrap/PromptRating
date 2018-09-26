
import Foundation

private struct PropertyKey {
    static let event = "event"
    static let eventCount = "eventCount"
    static let threshold = "threshold"
}

open class PromptCondition: NSObject, NSCoding {
    
    let event: PromptEvent
    var eventCount: Int
    var threshold: Int
    
    public init(event: PromptEvent,
                threshold: Int,
                eventCount: Int)
    {
        self.event = event
        self.threshold = threshold
        self.eventCount = eventCount
    }
    
    open func isSatisfied() -> Bool {
        
        return eventCount >= threshold
    }
    
    //MARK: NSObject
    
    open override func isEqual(_ object: Any?) -> Bool {
        
        if let otherObject = object as? PromptCondition {
            return otherObject.event == self.event &&
                otherObject.eventCount == self.eventCount &&
                otherObject.threshold == self.threshold
        }
        return false
    }
    
    //MARK: NSCoding
    
    open func encode(with aCoder: NSCoder) {
        aCoder.encode(event.value(), forKey: PropertyKey.event)
        aCoder.encode(eventCount, forKey: PropertyKey.eventCount)
        aCoder.encode(threshold, forKey: PropertyKey.threshold)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let event = PromptRatingEvent(name: aDecoder.decodeObject(forKey: PropertyKey.event) as! String)
        let eventCount = aDecoder.decodeInteger(forKey: PropertyKey.eventCount)
        let threshold = aDecoder.decodeInteger(forKey: PropertyKey.threshold)
        
        self.init(event: event, threshold: threshold, eventCount: eventCount)
    }
}
