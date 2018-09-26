
import XCTest
@testable import PromptRating

class PromptRuleShould: XCTestCase {
    
    var shareOfferRule: PromptRule!
    
    override func setUp() {
        super.setUp()
        
        shareOfferRule = PromptRule(
            forEvent: Event.ShareOffer
        )
    }
    
    func test_be_able_to_tell_if_an_event_is_relevant_for_the_current_conditions() {
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session)
        )
        
        XCTAssert(shareOfferRule.eventIsRelevant(Event.Session))
        XCTAssert(shareOfferRule.eventIsRelevant(Event.MinorVersion) == false)
    }
    
    func test_be_satisfied_when_the_specified_events_occurred() {
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session)
        )
        
        var events = generateEvents(Event.Session, 2)

        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session),
            (1, Event.MinorVersion)
        )
        
        events = generateEvents(Event.Session, 2) + generateEvents(Event.MinorVersion, 1)
        
        let _ = shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
    }
    
    func test_not_be_satisfied_when_less_than_the_specified_events_occurred() {
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session)
        )
        
        shareOfferRule.addEvents([Event.Session])
        XCTAssert(shareOfferRule.isSatisfied() == false)
    }
    
    func test_be_satisfied_after_more_than_the_specified_events_occurred() {
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session),
            (1, Event.MinorVersion)
        )
        
        let events = generateEvents(Event.Session, 3) + generateEvents(Event.MinorVersion, 1)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
    }
    
    func test_update_rules_when_provided_with_a_prompt_rating_result() {
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session),
            (1, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Positive, .Positive),
            showAfter:
                (5, Event.Session),
                (1, Event.MinorVersion)
        )
        
        let promptResult: PromptResult = (.Positive, .Positive)
        let _ = shareOfferRule.changeConditionsFor(promptResult)
        
        let events = generateEvents(Event.Session, 2) + generateEvents(Event.MinorVersion, 1)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied() == false)
    }
    
    func test_update_rules_accordingly_when_provided_with_several_prompt_results() {
        
        let _ = shareOfferRule.showForTheFirstTimeAfter(
            (2, Event.Session),
            (1, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Positive, .Positive),
            showAfter:
                (3, Event.Session),
                (1, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Positive, .Negative),
            showAfter:
                (1, Event.Session),
                (2, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Negative, .Positive),
            showAfter:
                (2, Event.Session),
                (7, Event.MinorVersion)
        ).whenPromptRatingIs(
            (.Negative, .Negative),
            showAfter:
                (8, Event.Session),
                (9, Event.MinorVersion)
        )

        var events = generateEvents(Event.Session, 2) + generateEvents(Event.MinorVersion, 1)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
        
        let _ = shareOfferRule?.changeConditionsFor(
            (.Positive, .Positive)
        )
        events = generateEvents(Event.Session, 3) + generateEvents(Event.MinorVersion, 1)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
        
        let _ = shareOfferRule?.changeConditionsFor(
            (.Positive, .Negative)
        )
        events = generateEvents(Event.Session, 1) + generateEvents(Event.MinorVersion, 2)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
        
        let _ = shareOfferRule?.changeConditionsFor(
            (.Negative, .Positive)
        )
        events = generateEvents(Event.Session, 2) + generateEvents(Event.MinorVersion, 7)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
        
        let _ = shareOfferRule?.changeConditionsFor(
            (.Negative, .Negative)
        )
        events = generateEvents(Event.Session, 8) + generateEvents(Event.MinorVersion, 9)
        shareOfferRule.addEvents(events)
        XCTAssert(shareOfferRule.isSatisfied())
    }
}
