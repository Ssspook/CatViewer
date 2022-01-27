import Foundation
import Combine

protocol NetworkProtocol {
    func loadPictureFromUrl(url: URL?) -> AnyPublisher<Data, APIError>
    func fetchData<T: Decodable>() throws -> AnyPublisher<T, APIError>
}
