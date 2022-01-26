import Foundation
import Combine

final class CatViewModel: ObservableObject, Identifiable {
    @Published var dataFetched = false
    @Published var displayErrorPicture = false
    let id = UUID()
    let cat: Cat
    let breeds: [Breed]?
    let catId: String
    let url: String
    let width: Int
    let height: Int
    
    var jsonPrettyString: String {
        prettyPrintData(cat)
    }
    
    private let networkManager: NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(cat: Cat, networker: NetworkProtocol) {
        self.cat = cat
        breeds = cat.breeds
        catId = cat.id
        url = cat.url
        width = cat.width
        height = cat.height
        self.networkManager = networker
    }
    
    func fetchImage() {
        networkManager.loadPictureFromUrl(url: URL(string: url))
            .sink { [weak self] completion in
                
                switch completion {
                case .failure(_):
                    self?.displayErrorPicture.toggle()
                case .finished:
                    self?.displayErrorPicture = false
                }
    
            } receiveValue: { [weak self] data in
                guard let urlString = self?.url else { return }
                
                ImageCache.shared.cacheData(for: urlString)
                self?.dataFetched.toggle()
            }
            .store(in: &cancellables)
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
