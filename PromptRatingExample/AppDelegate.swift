
import UIKit
import PromptRating

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var promptRating: PromptRating?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow()
        
        let rulesStore = UserDefaultsPromptRatingDataStore(userDefaults: UserDefaults.standard)
        
        promptRating = PromptRating(rulesStore: rulesStore)
        
        let shareOfferRule = PromptRule(
            forEvent: Event.ShareOffer
            ).showForTheFirstTimeAfter(
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
                (1, Event.MinorVersion)
            ).whenPromptRatingIs(
                (.Negative, .Negative),
                showAfter:
                (1, Event.MinorVersion)
        )
        
        promptRating!.setRules([shareOfferRule])
        
        let minorVersionTracker = MinorVersionEventTracker(
            storage: UserDefaults.standard,
            appInfo: AppInfo()
        )
        let sessionTracker = SessionEventTracker(
            storage: UserDefaults.standard
        )
        let monthTracker = MonthEventTracker(
            storage: UserDefaults.standard
        )
        promptRating!.setEventTrackers([minorVersionTracker, sessionTracker, monthTracker])
        
        window?.rootViewController = PromptRatingExampleViewController(promptRating: promptRating!)
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        promptRating?.saveCurrentState()
    }
}

class AppInfo: ApplicationData {
    
    func version() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    }
}
