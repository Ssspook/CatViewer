import Foundation
import Combine

final class CatsListViewModel: ObservableObject {
    @Published var cats = [CatViewModel]()
    @Published var showAlert = false
    private(set) var error: APIError?
    private let networker: NetworkProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(networker: NetworkProtocol) {
        self.networker = networker
    }
    
    func fetchCats() {
        do {
            try networker.fetchData()
                .sink(receiveCompletion: { [weak self] completion in
                    
                    switch completion {
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.error = error
                            self?.showAlert = true
                        }
                    case .finished: break
                    }
                    
                }, receiveValue: {
                    self.catParser(catsList: $0)
                })
                .store(in: &cancellables)
                
        } catch let error as APIError {
            DispatchQueue.main.async {
                self.error = error
                self.showAlert = true
            }
        } catch { }
        
        showAlert = false
    }
    
    private func catParser(catsList: [Cat]) {
        catsList.forEach { catElement in
            let newCatVM = CatViewModel(cat: catElement, networker: networker)
            
            newCatVM.fetchImage()
            self.cats.append(newCatVM)
        }
    }
}
