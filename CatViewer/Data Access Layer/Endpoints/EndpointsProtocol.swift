import Foundation

protocol EndpointsProtocol {
    var endpoint: Endpoint { get }
    func addQuery(name: String, value: String?)
    func deleteQuery(name: String)
}
