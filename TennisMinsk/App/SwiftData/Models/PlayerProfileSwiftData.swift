import Foundation
import SwiftData

@Model
final class PlayerProfileSwiftData {
    var name: String
    var avatarImageData: Data?

    init(name: String = "", avatarImageData: Data? = nil) {
        self.name = name
        self.avatarImageData = avatarImageData
    }
}
