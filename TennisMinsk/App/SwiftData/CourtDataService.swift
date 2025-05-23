import SwiftUICore
import Foundation
import SwiftData

final class CourtDataService {

    var modelContext: ModelContext!

    @MainActor static let shared = CourtDataService()

    private init() {}

    func fetchAllCourts() -> [CourtSwiftData] {
        let fetchDescriptor = FetchDescriptor<CourtSwiftData>()

        do {
            let notes: [CourtSwiftData] = try modelContext.fetch(fetchDescriptor)
            return notes
        } catch {
            print("Ошибка при извлечении данных: \(error.localizedDescription)")
            return []
        }
    }

    func fetchCourtByID(_ persistentID: String) -> CourtSwiftData? {
        let descriptor = FetchDescriptor<CourtSwiftData>(
            predicate: #Predicate { $0.persistentID == persistentID }
        )

        do {
            let notes: [CourtSwiftData] = try modelContext.fetch(descriptor)

            return notes.first
        } catch {
            print("Ошибка при извлечении данных: \(error.localizedDescription)")

            return nil
        }
    }

    func saveOrUpdateCourt(persistentID: String, rating: Int, comment: String) {
        if let existingCourtNote = fetchCourtByID(persistentID) {
            existingCourtNote.rating = rating
            existingCourtNote.comment = comment
            existingCourtNote.createdAt = Date()

            print("Обновлена существующая запись с persistentID: \(persistentID)")
        } else {
            let newCourtNote = CourtSwiftData(persistentID: persistentID, rating: rating, comment: comment)
            modelContext.insert(newCourtNote)

            print("Создана новая запись с persistentID: \(persistentID)")
        }

        saveChanges()
    }

    private func saveChanges() {
        do {
            try modelContext.save()

            print("Изменения сохранены в базе данных.")
        } catch {
            print("Ошибка при сохранении данных: \(error.localizedDescription)")
        }
    }

    func deleteCourtByID(_ persistentID: String) {
        if let courtNoteToDelete = fetchCourtByID(persistentID) {
            modelContext.delete(courtNoteToDelete)

            print("Удалена запись с persistentID: \(persistentID)")
            saveChanges()
        } else {
            print("Не найдена запись для удаления с persistentID: \(persistentID)")
        }
    }
}
