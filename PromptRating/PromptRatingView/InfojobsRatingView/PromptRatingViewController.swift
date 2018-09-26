
import UIKit

private struct Timings {
    static let InitialContentAppear = 0.5
    static let InitialAnimationDelay = 0.2
    static let InitialFadeInLabels = 0.3
    static let InitialFadeInLabelsDelay = 0.35
}

private struct Transformations {
    static let InitialLogoTransformation = CGAffineTransform(translationX: 0, y: 120)
    static let InitialIllustrationTransformation = CGAffineTransform(translationX: 0, y: 50)
}

open class PromptRatingViewController: UIViewController, PromptRatingView {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var illustrationImageView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    @IBOutlet weak var positiveButton: UIButton!
    @IBOutlet weak var negativeButton: UIButton!
    
    let heartAnimationFrames = Images.heartAnimationFrames()
    let starsAnimationFrames = Images.starsAnimationFrames()
    let appIconAnimationFrames = Images.appIconAnimationFrames()
    
    let presenter: PromptRatingViewPresenter
    
    public init(presenter: PromptRatingViewPresenter) {
        
        self.presenter = presenter
        
        super.init(
            nibName: "PromptRatingViewController",
            bundle: Bundle(for: PromptRatingViewController.classForCoder())
        )
        presenter.view = self

    }
    
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPositiveButton()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    //MARK: PromptRatingView
    
    open func showInitialState(_ configuration: PromptRatingViewConfiguration) {
        
        setupIllustration(withState: .initial, configuration: configuration)
        dispatchAfter(timeInterval: Timings.InitialAnimationDelay) {
            self.animateCurrentIllustration(reverse: false, completion: nil)
        }
        
        animateContentAppear()
        
        dispatchAfter(timeInterval: Timings.InitialFadeInLabelsDelay) {
            self.fadeInLabels()
        }
    }
    
    open func showPositiveOpinionState(_ configuration: PromptRatingViewConfiguration) {
        transitionTo(.positiveFeedback, configuration: configuration)
    }
    
    open func showNegativeOpinionState(_ configuration: PromptRatingViewConfiguration) {
        transitionTo(.negativeFeedback, configuration: configuration)
    }
    
    open func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Setup
    
    func setupIllustration(withState state: PromptRatingState, configuration: PromptRatingViewConfiguration) {
        
        textLabel.attributedText = configuration.titleText
        positiveButton.setAttributedTitle(configuration.positiveButtonText, for: UIControlState())
        negativeButton.setAttributedTitle(configuration.negativeButtonText, for: UIControlState())
        
        let animationFrames = frames(forState: state)
        illustrationImageView.image = animationFrames.first!
        illustrationImageView.animationImages = animationFrames
        illustrationImageView.animationRepeatCount = 1
    }
    
    func setupPositiveButton() {
        positiveButton.layer.cornerRadius = 2.0
        positiveButton.layer.masksToBounds = true
    }
    
    //MARK: Animations
    
    func animateCurrentIllustration(reverse: Bool, completion: (() -> Void)?) {
        
        let images = reverse ? illustrationImageView.animationImages!.reversed() : illustrationImageView.animationImages!
        let duration = animationDuration(with: images.count)
        
        if reverse {
            illustrationImageView.animationImages = images
        }
        
        illustrationImageView.image = images.last!
        illustrationImageView.animationDuration = duration
        illustrationImageView.startAnimating()
        
        if let completion = completion {
            dispatchAfter(timeInterval: duration, completion: completion)
        }
    }
    
    func transitionTo(_ state: PromptRatingState, configuration: PromptRatingViewConfiguration) {
        
        animateCurrentIllustration(reverse: true) {
            self.setupIllustration(withState: state, configuration: configuration)
            self.animateCurrentIllustration(reverse: false, completion: nil)
        }
    }
    
    func fadeInLabels() {
        let hiddenViews = [textLabel, positiveButton, negativeButton] as [Any]
        setViews(hiddenViews as! [UIView], alphaTo: 0.0)
        
        UIView.animate(withDuration: Timings.InitialFadeInLabels, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.setViews(hiddenViews as! [UIView], alphaTo: 1.0)
        }, completion: nil)
    }
    
    func animateContentAppear() {
    
        self.logoImageView.transform = Transformations.InitialLogoTransformation
        self.illustrationImageView.transform = Transformations.InitialIllustrationTransformation
        self.logoImageView.alpha = 0.0
        self.illustrationImageView.alpha = 0.0
        
        let logoAndIllustration = [logoImageView, illustrationImageView] as [UIView]
        
        setViews(logoAndIllustration, alphaTo: 0.0)
        
        UIView.animate(withDuration: Timings.InitialContentAppear, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.logoImageView.transform = CGAffineTransform.identity
            self.illustrationImageView.transform = CGAffineTransform.identity
            self.setViews(logoAndIllustration, alphaTo: 1.0)
        }, completion: nil)
    }
    
    //MARK: Button actions
    
    @IBAction func positiveButtonPressed(_ sender: AnyObject) {
        
        presenter.positiveButtonPressed()
    }
    
    @IBAction func negativeButtonPressed(_ sender: AnyObject) {
        
        presenter.negativeButtonPressed()
    }
    
    //MARK: Utils
    
    func setViews(_ views: [UIView], alphaTo alpha: Double) {
        for view in views {
            view.alpha = CGFloat(alpha)
        }
    }
    
    func animationDuration(with framesCount: Int) -> Double {
        
        let defaultUIKitFrameRate = 30.0
        return Double(framesCount)/defaultUIKitFrameRate
    }
    
    func dispatchAfter(timeInterval interval: TimeInterval, completion: @escaping () -> Void) {
        let delayTime = DispatchTime.now() + Double(Int64(interval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            completion()
        }
    }
    
    func frames(forState state: PromptRatingState) -> [UIImage] {
        switch state {
        case .initial:
            return heartAnimationFrames
        case .positiveFeedback:
            return starsAnimationFrames
        case .negativeFeedback:
            return appIconAnimationFrames
        }
    }
}
