import Foundation
import MapKit

struct Court: Identifiable {

    struct ContactInfo {
        let phoneNumbers: [String]
        let email: String?
        let website: URL?
    }

    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    let address: String
    let contact: ContactInfo
}

let courtsMinsk: [Court] = [
    Court(
        name: "Теннисный клуб Матч Поинт",
        location: CLLocationCoordinate2D(latitude: 53.958578, longitude: 27.59282),
        address: "4-й пер. Кольцова 6а, Минск, Минская область 220131, Беларусь",
        contact: Court.ContactInfo(
            phoneNumbers: ["+375 29 538-33-00"],
            email: nil,
            website: URL(string: "https://www.instagram.com/matchpoint.minsk")
        )
    ),
    Court(
        name: "Fox Tennis",
        location: CLLocationCoordinate2D(latitude: 53.941704, longitude: 27.623001),
        address: "ул. Севастопольская, Минск, Минская область",
        contact: Court.ContactInfo(
            phoneNumbers: ["+375 29 130-70-30"],
            email: nil,
            website: URL(string: "https://fox-tennis.by/")
        )
    ),
    Court(
        name: "Белорусская Федерация Пляжного Тенниса\nКЛУБ ТЕННИСА",
        location: CLLocationCoordinate2D(latitude: 53.951425, longitude: 27.581205),
        address: "ул. Кольцова 112, Минск, Минская область",
        contact: Court.ContactInfo(
            phoneNumbers: ["+375 29 310-55-55", "+375 17 240-48-28"],
            email: "info@tennisclub.by",
            website: URL(string: "https://tennisclub.by/")
        )
    ),
    Court(
        name: "Sporting Club",
        location: CLLocationCoordinate2D(latitude: 53.954946, longitude: 27.712304),
        address: "просп. Независимости, 193, Минск, Минская область",
        contact: Court.ContactInfo(
            phoneNumbers: ["+375 29 135 00 00"],
            email: "info@sporting.by",
            website: URL(string: "https://sporting.by/")
        )
    )
]
