import Foundation

struct Endpoint {
    var queryItems = [URLQueryItem]()
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
    
        components.scheme = "https"
        components.host = "api.thecatapi.com"
        components.path = "/v1/images/search"
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}
