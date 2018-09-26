
import UIKit

internal class Images: NSObject {
    
    internal static func heartAnimationFrames() -> [UIImage] {
        return images("ilu_1_anim_", count: 17)
    }
    
    internal static func starsAnimationFrames() -> [UIImage] {
        return images("ilu_2A_anim_", count: 18)
    }
    
    internal static func appIconAnimationFrames() -> [UIImage] {
        return images("ilu_2B_anim_", count: 17)
    }
    
    internal static func infojobsBlueLogo() -> UIImage {
        return image("infojobsBlueLogo")
    }
    
    fileprivate static func image(_ name: String) -> UIImage {
        
        return UIImage(named: name, in: Bundle(for: Images.classForCoder()), compatibleWith: nil)!
    }
    
    fileprivate static func images(_ prefix: String, count: Int) -> [UIImage] {
        var images = [UIImage]()
        for index in 1...count {
            images.append(image("\(prefix)\(index)"))
        }
        return images
    }
}
