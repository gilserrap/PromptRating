
import XCTest
@testable import PromptRating

enum Event: String, PromptEvent {
    
    case ShareOffer = "ShareOffer"
    case Session = "Session"
    case MinorVersion = "MinorVersion"
    case Month = "Month"
    
    func value() -> String {
        return rawValue
    }
}

class PromptRatingShould: XCTestCase {
    
    var rulesStore: UserDefaultsPromptRatingDataStore!
    var shareOfferRule: PromptRule!
    var firstMonthRule: PromptRule!
    var promptRating: PromptRating!
    var persistentPromptRating: PromptRating!
    
    override func setUp() {
        super.setUp()
        
        shareOfferRule = createShareOfferRule()
        firstMonthRule = createFirstMonthRule()

        rulesStore = UserDefaultsPromptRatingDataStore(
            userDefaults: UserDefaultsMock()
        )
        persistentPromptRating = PromptRating(rulesStore: rulesStore)
        persistentPromptRating.setRules([shareOfferRule, firstMonthRule])

        promptRating = PromptRating()
        promptRating.setRules([shareOfferRule, firstMonthRule])
    }
    
    func test_prompt_rating_callback_is_invoked_when_a_rule_is_satisfied() {
        
        let expectation = self.expectation(description: "")
        
        let events = generateEvents(Event.Session, 5)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer) { rule, _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { error in }
    }
    
    func test_after_prompt_rating_feedback_is_received_the_rules_should_change() {
        
        let expectation0 = expectation(description: "Fulfill after 5 sessions")
        let expectation1 = expectation(description: "Fulfill after 5 months")
        let expectation2 = expectation(description: "FulFill after 1 minor version")
        let expectation3 = expectation(description: "FulFill after 6 minor versions")
        let expectation4 = expectation(description: "Fulfill after 1 minor version, 2 months and 4 sessions")

        var index = 0
        
        let handlePromptRating: RuleTriggeredCallback = { rule, resultClosure in
            
            switch index {
            case 0:
                expectation0.fulfill()
                resultClosure((.Positive, .Positive))
            case 1:
                expectation1.fulfill()
                resultClosure((.Positive, .Negative))
            case 2:
                expectation2.fulfill()
                resultClosure((.Negative, .Positive))
            case 3:
                expectation3.fulfill()
                resultClosure((.Negative, .Negative))
            case 4:
                expectation4.fulfill()
            default: break
            }
            
            index = index + 1
        }
        
        var events = generateEvents(Event.Session, 5)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer, handlePromptRating: handlePromptRating)
        
        events = generateEvents(Event.Month, 5)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer, handlePromptRating: handlePromptRating)
        
        events = generateEvents(Event.MinorVersion, 1)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer, handlePromptRating: handlePromptRating)
        
        events = generateEvents(Event.MinorVersion, 6)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer, handlePromptRating: handlePromptRating)
        
        events = generateEvents(Event.MinorVersion, 1) + generateEvents(Event.Month, 2) + generateEvents(Event.Session, 4)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer, handlePromptRating: handlePromptRating)
        
        waitForExpectations(timeout: 2) { error in }
    }
    
    func test_maintain_the_rules_state_on_instanciation() {
        
        let expectKeepState1 = expectation(description: "")
        let expectKeepState2 = expectation(description: "")
        
        let shareRule = createShareOfferRule()
        persistentPromptRating!.setRules([shareRule])

        persistentPromptRating!.addEvents(generateEvents(Event.Session, 5))
        persistentPromptRating?.saveCurrentState()
        persistentPromptRating = nil
        
        persistentPromptRating = PromptRating(rulesStore: rulesStore)
        persistentPromptRating!.addEvent(Event.ShareOffer) { rule, resultCallback in
            
            resultCallback((.Positive, .Positive))
            
            XCTAssert(rule == shareRule)
            expectKeepState1.fulfill()
        }
        persistentPromptRating?.saveCurrentState()
        persistentPromptRating = nil

        persistentPromptRating = PromptRating(rulesStore: rulesStore)
        persistentPromptRating?.addEvents(generateEvents(Event.Month, 5))
        
        persistentPromptRating!.addEvent(Event.ShareOffer) { rule, resultCallback in
            let randomResult: PromptResult = (.Negative, .Negative)
            resultCallback(randomResult)
            
            XCTAssert(rule == shareRule)
            expectKeepState2.fulfill()
        }
        waitForExpectations(timeout: 2) { _ in }
    }
    
    func test_update_all_rules_when_user_feedback_is_received() {
        
        let expectation = self.expectation(description: "")
        
        let events = generateEvents(Event.Session, 5)
        promptRating.addEvents(events)
        promptRating.addEvent(Event.ShareOffer) { (rule, result) in
            result((.Positive, .Positive))
        }
        
        promptRating.addEvents(generateEvents(Event.MinorVersion, 2))
        
        promptRating.addEvent(Event.Month) { rule, _ in
            XCTAssertEqual(rule, self.firstMonthRule)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2) { _ in }
    }
    
    func test_add_only_new_rules() {
        
        let newRule = createNewRule()
        let existingRule = createShareOfferRule()
        
        persistentPromptRating.setRules([existingRule, newRule])
        persistentPromptRating.saveCurrentState()
        
        XCTAssert(rulesStore.getLastSavedRules().count == 2)
    }
    
    func test_remove_no_longer_valid_rules() {
        
        let theOnlyValidRule = createNewRule()
        
        persistentPromptRating.setRules([theOnlyValidRule])
        persistentPromptRating.saveCurrentState()
        
        XCTAssert(rulesStore.getLastSavedRules()[0] == theOnlyValidRule)
    }
}

func createShareOfferRule() -> PromptRule {
    return PromptRule(forEvent: Event.ShareOffer).showForTheFirstTimeAfter(
            (5, Event.Session)
        ).whenPromptRatingIs(
            (.Positive, .Positive),
            showAfter:
            (5, Event.Month)
        ).whenPromptRatingIs(
            (.Positive, .Negative),
            showAfter:
            (1, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Negative, .Positive),
            showAfter:
            (6, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Negative, .Negative),
            showAfter:
            (1, Event.MinorVersion),
            (2, Event.Month),
            (4, Event.Session)
        )
}

func createFirstMonthRule() -> PromptRule {

    return PromptRule(forEvent: Event.Month).showForTheFirstTimeAfter(
            (1, Event.Month)
        ).whenPromptRatingIs(
            (.Positive, .Positive),
            showAfter:
            (2, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Positive, .Negative),
            showAfter:
            (1, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Negative, .Positive),
            showAfter:
            (1, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Negative, .Negative),
            showAfter:
            (1, Event.MinorVersion)
        )
}

func createNewRule() -> PromptRule {
    return PromptRule(forEvent: Event.MinorVersion).showForTheFirstTimeAfter(
        (2, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Positive, .Negative),
            showAfter: (3, Event.ShareOffer)
        )
}

class UserDefaultsMock: UserDefaults {
    
    var storedObjects = [String: AnyObject]()
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if let value = value {
            storedObjects[defaultName] = value as AnyObject?
        }
    }
    
    override func object(forKey defaultName: String) -> Any? {
        return storedObjects[defaultName]
    }
}
