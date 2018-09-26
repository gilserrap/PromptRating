
import Foundation

public struct PromptRatingViewConfiguration {
    
    let titleText: NSAttributedString
    let positiveButtonText: NSAttributedString
    let negativeButtonText: NSAttributedString
    
    public init(titleText: NSAttributedString,
                positiveButtonText: NSAttributedString,
                negativeButtonText: NSAttributedString)
    {
        self.titleText = titleText
        self.positiveButtonText = positiveButtonText
        self.negativeButtonText = negativeButtonText
    }
}

public protocol PromptRatingView: class {
    
    func showInitialState(_ configuration: PromptRatingViewConfiguration)
    func showPositiveOpinionState(_ configuration: PromptRatingViewConfiguration)
    func showNegativeOpinionState(_ configuration: PromptRatingViewConfiguration)
    func dismiss()
}
