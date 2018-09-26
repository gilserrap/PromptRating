
import XCTest
@testable import PromptRating


class UserDefaultsPromptRatingDataStoreShould: XCTestCase {
    
    var dataStore: UserDefaultsPromptRatingDataStore!
    
    override func setUp() {
        super.setUp()
        
        let userDefaults = UserDefaults.standard
        dataStore = UserDefaultsPromptRatingDataStore(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        
        dataStore.reset()
        
        super.tearDown()
    }
    
    func test_store_and_retrieve_prompt_rating_rules() {
        let shareRule = PromptRule(
            forEvent: Event.ShareOffer
        ).showForTheFirstTimeAfter(
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
        
        let versionRule = PromptRule(
            forEvent: Event.MinorVersion
            ).showForTheFirstTimeAfter(
                (1, Event.MinorVersion)
            )
        
        dataStore.saveCurentRules([shareRule, versionRule])
        
        let storedRules = dataStore.getLastSavedRules()
 
        if storedRules.count > 1 {
            let firstStoredRule = storedRules.first
            let secondStoredRule = storedRules[1]
            XCTAssert(firstStoredRule == shareRule)
            XCTAssert(secondStoredRule == versionRule)
        } else {
            XCTAssert(false)
        }
    }
}
