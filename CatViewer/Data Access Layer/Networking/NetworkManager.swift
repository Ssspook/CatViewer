import Foundation
import Combine

final class NetworkManager : NetworkProtocol {
    private var endpointManager: EndpointsProtocol
    private var NetworkConstants = Constants.Network.self
    
    private var endpoint: Endpoint {
        endpointManager.endpoint
    }
    
    init(numberOfCats: Int, endpointHandler: EndpointsProtocol = EndpointsManager()) {
        endpointManager = endpointHandler
        endpointManager.addQuery(name: "limit", value: String(numberOfCats))
    }
    
    func loadPictureFromUrl(url: URL?) -> AnyPublisher<Data, APIError> {
       guard let url = url else { fatalError("Problems with url") }
        
       return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ [weak self] (data, response) -> Data in
                
                do {
                    try self?.validateResponse(response)
                } catch {
                    let httpResponse = response as? HTTPURLResponse
                    
                    if let httpResponse = httpResponse {
                        throw APIError.badResponce(statusCode: httpResponse.statusCode)
                    }
                }
                
                return data
            })
            .mapError { APIError.convert(error: $0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchData<T: Decodable>() throws -> AnyPublisher<T, APIError> {
       validatePagination()
        
       return URLSession.shared.dataTaskPublisher(for: endpoint.url)
            .tryMap({ [weak self] (data, response) -> Data in
                do {
                    try self?.validateResponse(response)
                } catch {
                    let httpResponse = response as? HTTPURLResponse
                    
                    if let httpResponse = httpResponse {
                        throw APIError.badResponce(statusCode: httpResponse.statusCode)
                    }
                }
                
                return data
            })
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { APIError.convert(error: $0) }
            .retry(NetworkConstants.retryTimes)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func validatePagination() {
        guard let queryItem = endpoint.queryItems.first(where: { $0.name == "order" }) else {
            return
        }
        
        if shouldPageQueryBeAdded(queryItem) {
            endpointManager.addQuery(name: "page", value: NetworkConstants.deafultPage)
        }
    }
    
    private func shouldPageQueryBeAdded(_ queryItem: URLQueryItem) -> Bool {
        guard let queryItemValue = queryItem.value else { return false }
        
        return queryItemValue != "RAND"
    }
    
    private func validateResponse(_ response: URLResponse?) throws {
        
        if let response = response as? HTTPURLResponse,
           !(200...299).contains(response.statusCode) {
            
            throw APIError.badResponce(statusCode: response.statusCode)
        }
    }
}
