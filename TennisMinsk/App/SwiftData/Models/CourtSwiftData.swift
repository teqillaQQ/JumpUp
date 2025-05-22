import Foundation
import SwiftData

@Model
final class CourtSwiftData {

    var persistentID: String
    var rating: Int
    var comment: String
    var createdAt: Date

    init(persistentID: String, rating: Int, comment: String, createdAt: Date = Date()) {
        self.persistentID = persistentID
        self.rating = rating
        self.comment = comment
        self.createdAt = createdAt
    }
}
