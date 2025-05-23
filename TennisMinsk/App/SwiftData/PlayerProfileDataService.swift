import Foundation
import SwiftData

final class PlayerProfileDataService {

    var modelContext: ModelContext!

    @MainActor static let shared = PlayerProfileDataService()

    private init() {}

    func fetchProfile() -> PlayerProfileSwiftData? {
        var fetchDescriptor = FetchDescriptor<PlayerProfileSwiftData>()
        fetchDescriptor.fetchLimit = 1

        do {
            let temp = try modelContext.fetch(fetchDescriptor)
            print(temp)

            return try modelContext.fetch(fetchDescriptor).first
        } catch {
            print("Ошибка при извлечении профиля: \(error.localizedDescription)")
            return nil
        }
    }

    func createOrUpdateProfile(name: String, avatarImageData: Data?) {
        if let existingProfile = fetchProfile() {
            existingProfile.name = name
            existingProfile.avatarImageData = avatarImageData

            print("Обновлён профиль игрока.")
        } else {
            let newProfile = PlayerProfileSwiftData(name: name, avatarImageData: avatarImageData)
            modelContext.insert(newProfile)

            print("Создан новый профиль игрока.")
        }

        saveChanges()
    }

    func deleteProfile() {
        if let existingProfile = fetchProfile() {
            modelContext.delete(existingProfile)
            print("Профиль игрока удалён.")
            saveChanges()
        } else {
            print("Нет профиля для удаления.")
        }
    }

    private func saveChanges() {
        do {
            try modelContext.save()
            print("Изменения сохранены в базе данных.")
        } catch {
            print("Ошибка при сохранении данных: \(error.localizedDescription)")
        }
    }
}
