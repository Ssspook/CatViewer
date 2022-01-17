import Foundation

class StructWrapper<T>: NSObject {
    let value: T
    
    init(_ data: T) {
        value = data
    }
}
