import Foundation

/*
 what for?
 why not to use data directly?
*/

class StructWrapper<T>: NSObject {
    let value: T

  // why parameter named data as this type is generic
    init(_ data: T) {
        value = data
    }
}
