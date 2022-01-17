import Foundation

struct Cat: Codable {    
    let breeds: [Breed]?
    let id: String
    let url: String
    let width, height: Int
}

struct Breed: Codable {
    let weight: Weight
    let id, name: String
}

struct Weight : Codable {
    var imperial: String
    var metric: String
}

