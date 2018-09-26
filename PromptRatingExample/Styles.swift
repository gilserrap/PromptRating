
import UIKit
import PromptRating

struct Styles {

    static func promptRatingConfigurations() -> (PromptRatingViewConfiguration, PromptRatingViewConfiguration, PromptRatingViewConfiguration) {
        
        let initialConfiguration = PromptRatingViewConfiguration(
            titleText: Styles.titleText(text: "¿Te gusta la App de Infojobs?"),
            positiveButtonText: Styles.buttonText1(text: "SI, ME ENCANTA"),
            negativeButtonText: Styles.buttonText2(text: "NO ME GUSTA")
        )
        
        let positiveConfiguration = PromptRatingViewConfiguration(
            titleText: Styles.titleText(text: "¡Genial! Muchas gracias. ¿Nos valoras en App Store?"),
            positiveButtonText: Styles.buttonText1(text: "VALORAR"),
            negativeButtonText: Styles.buttonText2(text: "AHORA NO")
        )
        
        let negativeConfiguration = PromptRatingViewConfiguration(
            titleText: Styles.titleText(text: "Vaya… ¿Qué deberíamos mejorar?"),
            positiveButtonText: Styles.buttonText1(text: "DÉJANOS TUS SUGERENCIAS"),
            negativeButtonText: Styles.buttonText2(text: "AHORA NO")
        )
        
        return(initialConfiguration, positiveConfiguration, negativeConfiguration)
    }
    
    static func titleText(text: String) -> NSAttributedString {
        
        let titleAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
                               NSForegroundColorAttributeName: UIColor(red: 45.0/255.0, green: 49.0/255.0, blue: 51.0/255.0, alpha: 1.0)]
        
        return NSAttributedString(
            string: text,
            attributes: titleAttributes
        )
    }
    
    static func buttonText1(text: String) -> NSAttributedString {
        
        let titleAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
                               NSForegroundColorAttributeName: UIColor.white]
        
        return NSAttributedString(
            string: text,
            attributes: titleAttributes
        )
    }
    
    static func buttonText2(text: String) -> NSAttributedString {
        
        let titleAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17),
                               NSForegroundColorAttributeName: UIColor(red: 32.0/255.0, green: 136.0/255.0, blue: 194.0/255.0, alpha: 1.0)]
        
        return NSAttributedString(
            string: text,
            attributes: titleAttributes
        )
    }
}
