import Foundation
import Combine

final class CatViewModel: ObservableObject, Identifiable {
    @Published var dataFetched = false
    @Published var displayErrorPicture = false
    let id = UUID()
    let catDTO: Cat
    let breeds: [Breed]?
    let catId: String
    let url: String
    let width, height: Int
    
    var jsonPrettyString: String {
        prettyPrintData(catDTO)
    }
    
    private let _networkManager: NetworkProtocol
    private var _cancellables = Set<AnyCancellable>()
    
    init(catDTO: Cat, networkManager: NetworkProtocol) {
        self.catDTO = catDTO
        breeds = catDTO.breeds
        catId = catDTO.id
        url = catDTO.url
        width = catDTO.width
        height = catDTO.height
        _networkManager = networkManager
    }
    
    func fetchImage() {
        _networkManager.loadPictureFromUrl(url: URL(string: url))
            .sink { [unowned self] completion in
                
                switch completion {
                case .failure(_):
                    self.displayErrorPicture.toggle()
                case .finished:
                    self.displayErrorPicture = false
                }
    
            } receiveValue: { [unowned self] data in
                DataCache.shared.cacheData(itemToCache: StructWrapper(data), for: self.url)
                self.dataFetched.toggle()
            }
            .store(in: &_cancellables)
    }
    
    private func prettyPrintData(_ encodingObject: Cat) -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData: Data
        
        do {
            jsonData = try jsonEncoder.encode(encodingObject)
        } catch {
            return "No data available"
        }
        
        return transformToPrettyPrint(jsonData)
    }
    
    private func transformToPrettyPrint(_ jsonData: Data) -> String {
        
        if let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers),
           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            
            return String(decoding: jsonData, as: UTF8.self).replacingOccurrences(of: "\\", with: "")
        } else {
           return "Json data is damaged"
        }
    }
}

extension CatViewModel: Equatable {
    static func == (lhs: CatViewModel, rhs: CatViewModel) -> Bool {
        if lhs.url == rhs.url {
            return true
        }
        
        return false
    }
    
}
