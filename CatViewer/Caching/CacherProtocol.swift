import Foundation

protocol CacherProtocol {
    func cacheData(for: String?)
    func getData(for: String?) -> Data?
}
