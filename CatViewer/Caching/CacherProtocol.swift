import Foundation

protocol CacherProtocol {
    associatedtype CachingItem
    
    func cacheData(itemToCache : CachingItem, for: String)
    func getData(for: String) -> CachingItem?
}
