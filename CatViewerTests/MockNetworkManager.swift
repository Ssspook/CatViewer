import Foundation
@testable import CatViewer
import UIKit
import Combine

final class MockNetworkManager: NetworkProtocol {
    var urlPicturesDictionary = [
        "url1" : UIImage(named: "cat1")?.jpegData(compressionQuality: 1.0),
        "url2" : UIImage(named: "cat2")?.jpegData(compressionQuality: 1.0),
        "url3" : UIImage(named: "cat1")?.jpegData(compressionQuality: 1.0)
    ]
    
    var catsData: [String]
    
    
    private var _queries = [String: String]()
    
    init(catsData: [String]) {
        self.catsData = catsData
    }
    
    func loadPictureFromUrl(url: URL?) -> AnyPublisher<Data, APIError> {
        
        urlPicturesDictionary.publisher
            .filter { $0.0 == url?.description }
            .tryMap { $0.1! }
            .mapError({ error in
                APIError.convert(error: error)
            })
            .eraseToAnyPublisher()
    }
    
    func fetchData<T>() throws -> AnyPublisher<T, APIError> where T : Decodable {
        
         catsData.publisher
            .map { $0.data(using: .utf8)! }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ error in
                APIError.convert(error: error)
            })
            .eraseToAnyPublisher()
    }
    
    func addQuery(name: String, value: String?) { }
    
    func deleteQuery(name: String) { }
}
