import SwiftUI

@MainActor
final class PlayerProfileViewModel: ObservableObject {

    @Published var name: String = ""
    @Published var avatarImage: UIImage?

    private let service = PlayerProfileDataService.shared

    func loadProfile() {
        if let profile = service.fetchProfile() {
            name = profile.name
            if let data = profile.avatarImageData {
                avatarImage = UIImage(data: data)
            }
        }
    }

    func saveProfile() {
        let avatarData = avatarImage?.jpegData(compressionQuality: 0.8)
        service.createOrUpdateProfile(name: name, avatarImageData: avatarData)
    }

    func deleteProfile() {
        service.deleteProfile()
        name = ""
        avatarImage = nil
    }
}
