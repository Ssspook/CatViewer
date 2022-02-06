import Foundation

extension Cat: Equatable {
    static func == (lhs: Cat, rhs: Cat) -> Bool {
        lhs.id == rhs.id
    }
}
