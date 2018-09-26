
import Foundation

public protocol PromptRatingDataStore {
    
    func saveCurentRules(_ currentRules: [PromptRule])
    func getLastSavedRules() -> [PromptRule]
}
