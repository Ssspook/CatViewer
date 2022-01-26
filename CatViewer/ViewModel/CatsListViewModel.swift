import Foundation
import Combine
import SwiftUI

final class CatsListViewModel: ObservableObject {
    @Published var cats = [CatViewModel]()
    @Published var showAlert = false
    private(set) var error: APIError?
    private let networkManager: NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
    }
    
    func fetchCats() {
        do {
            try networkManager.fetchData()
                .sink(receiveCompletion: { [weak self] completion in
                    
                    switch completion {
                    case .failure(let error):
                        self?.error = error
                        self?.showAlert = true
                    case .finished: break
                    }
                    
                }, receiveValue: {
                    self.catParser(catsList: $0)
                })
                .store(in: &cancellables)
            
        } catch let error as APIError {
            self.error = error
            showAlert = true
        } catch { }
        
        showAlert = false
    }
    
    private func catParser(catsList: [Cat]) {
        catsList.forEach { catElement in
            let catVM = CatViewModel(cat: catElement, networker: networkManager)
            
            catVM.fetchImage()
            self.cats.append(catVM)
        }
    }
}
