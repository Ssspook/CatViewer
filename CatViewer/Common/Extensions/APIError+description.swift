import Foundation

extension APIError {
    var description: String {
        switch self {
        case .urlComposing:
            return "Problems, composing url"
        case .url:
            return "Bad url"
        case .badResponce:
            return "Bad responce"
        case .unknown:
            return "Unknown error"
        }
    }
}
