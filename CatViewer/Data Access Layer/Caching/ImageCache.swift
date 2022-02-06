import Foundation

class ImageCache: CacherProtocol {
    
    static let shared = ImageCache()
    
    private init() {
        URLCache.shared.memoryCapacity = Constants.Network.cahceMemoryCapacity
    }
    
    func cacheData(for urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let cachedURLResponce = URLCache.shared.cachedResponse(for: urlRequest) {
            URLCache.shared.storeCachedResponse(cachedURLResponce, for: urlRequest)
        }
    }
    
    func getData(for urlString: String?) -> Data? {
        var pictureData: Data?
        
        guard let urlString = urlString else {
            return nil
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let urlRequest = URLRequest(url: url)
        URLCache.shared.getCachedResponse(for: URLSession.shared.dataTask(with: urlRequest)) { cachedResponce in
            if let cachedResponce = cachedResponce {
                pictureData = cachedResponce.data
            }
        }
        
        return pictureData
    }
}
