import Foundation
import Combine
import SwiftUI

final class CatsListViewModel: ObservableObject {
    @Published var cats = [CatViewModel]()
    @Published var showAlert = false
    private(set) var error: APIError?
    private let _networkManager: NetworkProtocol
    private var _cancellables = Set<AnyCancellable>()
    
    init(networkManager: NetworkProtocol) {
        _networkManager = networkManager
    }
    
    func fetchCats() {
        do {
            try _networkManager.fetchData()
                .sink(receiveCompletion: { [unowned self] completion in
                    
                    switch completion {
                    case .failure(let error):
                        self.error = error
                        showAlert = true
                    case .finished:
                        showAlert = false
                    }
                    
                }, receiveValue: {
                    self.catParser(catsList: $0)
                })
                .store(in: &_cancellables)
            
        } catch let error as APIError {
            self.error = error
            showAlert = true
        } catch { }
        
        showAlert = false
    }
    
    private func catParser(catsList: [Cat]) {
        catsList.forEach { catElement in
            let catVM = CatViewModel(catDTO: catElement, networkManager: _networkManager)
            
            catVM.fetchImage()
            self.cats.append(catVM)
        }
    }
}
