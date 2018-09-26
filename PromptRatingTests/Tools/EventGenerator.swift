
@testable import PromptRating

func generateEvents(_ event: PromptEvent, _ times: Int) -> [PromptEvent] {
    
    return (1...times).map { _ in return event }
}
