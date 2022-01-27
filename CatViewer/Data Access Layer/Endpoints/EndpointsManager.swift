import Foundation

class EndpointsManager: EndpointsProtocol {
    private(set) var endpoint: Endpoint
    
    init() {
        endpoint = Endpoint()
    }
    
    func addQuery(name: String, value: String?) {
        let queryItem = URLQueryItem(name: name, value: value)

        endpoint.queryItems.append(queryItem)
    }
    
    func deleteQuery(name: String) {
        guard let queryItem = endpoint.queryItems.first(where: { $0.name == name}) else { fatalError("No such query") }
        
        if let indexOfQueryToDelete = endpoint.queryItems.firstIndex(of: queryItem) {
            endpoint.queryItems.remove(at: indexOfQueryToDelete)
        }
    }
}
