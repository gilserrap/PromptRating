
import Foundation

enum PromptRatingState {
    case initial, positiveFeedback, negativeFeedback
}

open class PromptRatingViewPresenter {
    
    weak var view: PromptRatingView?
    
    fileprivate var currentState: PromptRatingState = .initial
    
    fileprivate let initialConfiguration: PromptRatingViewConfiguration
    fileprivate let positiveConfiguration: PromptRatingViewConfiguration
    fileprivate let negativeConfiguration: PromptRatingViewConfiguration
    
    fileprivate let onFinishPromptRating: PromptResultCallback
    
    public init(initialConfiguration: PromptRatingViewConfiguration,
                positiveConfiguration: PromptRatingViewConfiguration,
                negativeConfiguration: PromptRatingViewConfiguration,
                onFinishPromptRating: @escaping PromptResultCallback)
    {
        self.initialConfiguration = initialConfiguration
        self.positiveConfiguration = positiveConfiguration
        self.negativeConfiguration = negativeConfiguration
        self.onFinishPromptRating = onFinishPromptRating
    }
    
    func viewWillAppear() {
        view?.showInitialState(initialConfiguration)
    }
    
    func positiveButtonPressed() {
        
        switch currentState {
        case .initial:
            view?.showPositiveOpinionState(positiveConfiguration)
        case .positiveFeedback:
            view?.dismiss()
            onFinishPromptRating((.Positive, .Positive))
        case .negativeFeedback:
            view?.dismiss()
            onFinishPromptRating((.Negative, .Positive))
        }
        currentState = .positiveFeedback
    }
    
    func negativeButtonPressed() {

        switch currentState {
        case .initial:
            view?.showNegativeOpinionState(negativeConfiguration)
        case .positiveFeedback:
            view?.dismiss()
            onFinishPromptRating((.Positive, .Negative))
        case .negativeFeedback:
            view?.dismiss()
            onFinishPromptRating((.Negative, .Negative))
        }
        currentState = .negativeFeedback
    }
}
