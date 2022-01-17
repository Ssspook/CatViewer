import Foundation
import Combine

protocol NetworkProtocol {
    func loadPictureFromUrl(url: URL?) -> AnyPublisher<Data, APIError>
    func fetchData<T: Decodable>() throws -> AnyPublisher<T, APIError>
    func addQuery(name: String, value: String?)
    func deleteQuery(name: String)
}
