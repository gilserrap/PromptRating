
import XCTest
@testable import PromptRating

class PromptConditionShould: XCTestCase {

    var promptConditionForSessionEvent: PromptCondition!
    
    override func setUp() {
        super.setUp()
        
        promptConditionForSessionEvent = PromptCondition(event: Event.Session, threshold: 2 ,eventCount: 0)
    }
    
    func test_be_satisfied_when_the_event_count_is_greater_that_or_equal_to_the_threshold() {
        
        promptConditionForSessionEvent.eventCount = 1
        
        XCTAssert(!promptConditionForSessionEvent.isSatisfied())
        
        promptConditionForSessionEvent.eventCount = 2
        
        XCTAssert(promptConditionForSessionEvent.isSatisfied())
        
        promptConditionForSessionEvent.eventCount = 3
        
        XCTAssert(promptConditionForSessionEvent.isSatisfied())
    }
}
