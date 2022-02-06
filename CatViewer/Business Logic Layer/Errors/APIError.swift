import Foundation

enum APIError: Error, CustomStringConvertible {
    case urlComposing
    case url(URLError?)
    case badResponce(statusCode: Int)
    case unknown(Error)
}

// Why not
// extension Error {
//   var asApiError: APIError? {

extension APIError {
    static func convert(error: Error) -> APIError {
        switch error {
        case is URLError:
            // is there any situation when parameter is nil? seems like this place is the only to create APIError.url()
            return .url(error as? URLError)
        case is APIError:
            return error as! APIError
        default:
            return .unknown(error)
        }
    }
}
