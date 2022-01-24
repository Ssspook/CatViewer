import Foundation

class DataCache: NSCache<NSString, StructWrapper<Data>>, CacherProtocol {
    static let shared = DataCache()
    
    private override init() {}
    
    func cacheData(itemToCache dataWrapped: StructWrapper<Data>, for key: String) {
        let keyString = NSString(string: key)

        self.setObject(dataWrapped, forKey: keyString)
    }
    
    func getData(for key: String) -> StructWrapper<Data>? {
        let keyString = NSString(string: key)
      // try not to use self. if it is not required
        let dataWrapper = self.object(forKey: keyString)

        return dataWrapper
    }
}
