import Foundation

extension APIError {
    var name: String {
        switch self {
        case .urlComposing:
            return "Url composing failure"
        case .url:
            return "Url request filed"
        case .badResponce:
            return "Response data corruption"
        case .unknown:
            return "Error"
        }
    }
}
