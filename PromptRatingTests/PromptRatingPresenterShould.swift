
import XCTest
@testable import PromptRating

class PromptRatingPresenterShould: XCTestCase {

    var presenter: PromptRatingViewPresenter!
    var view: PromptRatingViewMock!
    var promptRatingResult: PromptResult?

    override func setUp() {
        super.setUp()
        
        presenter = PromptRatingViewPresenter(
            initialConfiguration: promptRatingConfiguration(),
            positiveConfiguration: promptRatingConfiguration(),
            negativeConfiguration: promptRatingConfiguration()
        ) { result in
            self.promptRatingResult = result
        }
        view = PromptRatingViewMock()
        presenter.view = view
    }
    
    func test_setup_the_initial_state_when_view_appears() {
        
        presenter.viewWillAppear()
        
        XCTAssert(view.showInitialStateExecuted)
    }
    
    func test_setup_the_positive_state_when_positive_button_is_pressed() {
        
        presenter.positiveButtonPressed()
        
        XCTAssert(view.showPositiveOpinionStateExecuted)
    }
    
    
    func test_setup_the_negative_state_when_positive_button_is_pressed() {
        
        presenter.negativeButtonPressed()
        
        XCTAssert(view.showNegativeOpinionStateExecuted)
    }
    
    func test_dismiss_and_return_resulting_information_on_prompt_rating_completed() {
        
        presenter.positiveButtonPressed()
        presenter.positiveButtonPressed()
        
        XCTAssert(view.dismissExecuted)
        XCTAssert(promptRatingResult! == (.Positive, .Positive))
        
        setUp()
        
        presenter.positiveButtonPressed()
        presenter.negativeButtonPressed()
        
        XCTAssert(view.dismissExecuted)
        XCTAssert(promptRatingResult! == (.Positive, .Negative))
        
        setUp()
        
        presenter.negativeButtonPressed()
        presenter.positiveButtonPressed()
        
        XCTAssert(view.dismissExecuted)
        XCTAssert(promptRatingResult! == (.Negative, .Positive))
        
        setUp()
        
        presenter.negativeButtonPressed()
        presenter.negativeButtonPressed()

        XCTAssert(view.dismissExecuted)
        XCTAssert(promptRatingResult! == (.Negative, .Negative))
    }
}

func promptRatingConfiguration() -> PromptRatingViewConfiguration {
    
    return PromptRatingViewConfiguration(
        titleText: NSAttributedString(string: ""),
        positiveButtonText: NSAttributedString(string: ""),
        negativeButtonText: NSAttributedString(string: "")
    )
}

class PromptRatingViewMock: PromptRatingView {
    
    var showInitialStateExecuted = false
    var showPositiveOpinionStateExecuted = false
    var showNegativeOpinionStateExecuted = false
    var dismissExecuted = false
    
    func showInitialState(_ configuration: PromptRatingViewConfiguration) {
        showInitialStateExecuted = true
    }
    
    func showPositiveOpinionState(_ configuration: PromptRatingViewConfiguration) {
        showPositiveOpinionStateExecuted = true
    }
    
    func showNegativeOpinionState(_ configuration: PromptRatingViewConfiguration) {
        showNegativeOpinionStateExecuted = true
    }
    
    func dismiss() {
        dismissExecuted = true
    }
}
