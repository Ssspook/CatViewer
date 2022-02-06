import Foundation
/*
 Is this decision somehow worse than
 extension Error {
    var asApiError: APIError? {
        ...
 ?
 
 Just dont quite get the idea. We will either way cast Error to our type.
 The choice is between APIError.convert(...) and error.asApiError
 */
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
}
