import Foundation
import CoreGraphics
class Constants {
    enum UIParameters {
        static let spacingBetweenViewElements: CGFloat = 16
        static let cornerRadius: CGFloat = 16
        static let baseHeight: CGFloat = 50
        static let baseWidth: CGFloat = 50
        static let buttonWidth: CGFloat = 200
        static let buttonHeight: CGFloat = 100
    }
    
    enum Network {
        static let numberOfCats = 1
        static let deafultPage = "1"
        static let loadTime: Double = 7
        static let retryTimes = 3
        static let cahceMemoryCapacity = 1024 * 1024 * 512
    }
}
