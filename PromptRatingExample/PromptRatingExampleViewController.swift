
import UIKit
import PromptRating

class PromptRatingExampleViewController: UIViewController {
    
    let promptRating: PromptRating
    
    init(promptRating: PromptRating) {
        self.promptRating = promptRating
        
        super.init(
            nibName: "PromptRatingExampleViewController",
            bundle: nil
        )
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        
        promptRating.addEvent(Event.ShareOffer) { (rule, resultCallback) in
            self.presentPromptRatingWithResultCallback(callback: resultCallback)
        }
    }
    
    @IBAction func monthButtonPressed(_ sender: AnyObject) {
    
        promptRating.addEvents([Event.Month])
    }
    
    @IBAction func sessionButtonPressed(_ sender: AnyObject) {
        
        promptRating.addEvents([Event.Session])
    }
    
    @IBAction func minorVersionButtonPressed(_ sender: AnyObject) {
        
        promptRating.addEvents([Event.MinorVersion])
    }
    
    @IBAction func forceShowButtonPressed(_ sender: AnyObject) {
        presentPromptRatingWithResultCallback { _ in }
    }
    
    func presentPromptRatingWithResultCallback(callback: @escaping PromptResultCallback) {
        
        let configurations = Styles.promptRatingConfigurations()
        let presenter = PromptRatingViewPresenter(
            initialConfiguration: configurations.0,
            positiveConfiguration: configurations.1,
            negativeConfiguration: configurations.2,
            onFinishPromptRating: callback
        )
        let promptRatingViewController = PromptRatingViewController(
            presenter: presenter
        )
        self.present(
            promptRatingViewController, animated: true, completion: nil
        )
    }
}
