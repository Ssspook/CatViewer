import Foundation
import Combine

final class NetworkManager : NetworkProtocol {
    private var _components: URLComponents

    init(numberOfCats: Int) {
        _components = URLComponents()
        
        _components.queryItems = [URLQueryItem]()
        _components.scheme = "https"
        _components.host = "api.thecatapi.com"
        _components.path = "/v1/images/search"

        let queryItem = URLQueryItem(name: "limit", value: String(numberOfCats))
        _components.queryItems?.append(queryItem)
    }
    
    func loadPictureFromUrl(url: URL?) -> AnyPublisher<Data, APIError> {
       guard let url = url else { fatalError("Problems with url") }
        
       return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> Data in
                
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw APIError.badResponce(statusCode: response.statusCode)
                } else {
                    return data
                }
            })
            .receive(on: DispatchQueue.main)
            .mapError({ error in
                APIError.convert(error: error)
            })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    func fetchData<T: Decodable>() throws -> AnyPublisher<T, APIError> {
        guard let url = _components.url else { throw APIError.urlComposing }
       
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> Data in
                
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw APIError.badResponce(statusCode: response.statusCode)
                } else {
                    return data
                }
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .mapError({ error in
                APIError.convert(error: error)
            })
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    func addQuery(name: String, value: String?) {
        let queryItem = URLQueryItem(name: name, value: value)

        _components.queryItems?.append(queryItem)
    }
    
    func deleteQuery(name: String) {
        guard let queryItem = _components.queryItems?.first(where: { $0.name == name}) else { fatalError("No such query") }
        
        if let indexOfQueryToDelete = _components.queryItems?.firstIndex(of: queryItem) {
            _components.queryItems?.remove(at: indexOfQueryToDelete)
        }
    }
}
