import Foundation

enum APIError: Error, CustomStringConvertible {
    case urlComposing
    case url(URLError?)
    case badResponce(statusCode: Int)
    case unknown(Error)
}

extension APIError {
    static func convert(error: Error) -> APIError {
        switch error {
        case is URLError:
            return .url(error as? URLError)
        case is APIError:
            return error as! APIError
        default:
            return .unknown(error)
        }
    }
    
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
