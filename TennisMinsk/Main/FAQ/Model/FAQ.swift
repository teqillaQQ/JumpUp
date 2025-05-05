import Foundation

struct FAQ: Identifiable, Decodable {
    let id: String
    let question: String
    let answer: String
}
