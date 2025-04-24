import CoreLocation

struct Court: Identifiable {

    enum SurfaceType: CaseIterable {
        case hard
        case clay
        case grass
        case carpet
        case artificialTurf
        case unknown
    }

    enum CourtType: CaseIterable {
        case indoor
        case outdoor
        case mixed
        case unknown
    }

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
    let surface: [SurfaceType]
    let type: CourtType
}

struct CourtsData {
    static let courtsMinsk: [Court] = [
        Court(
            name: "Теннисный клуб \nМатч Поинт",
            location: CLLocationCoordinate2D(latitude: 53.958578, longitude: 27.59282),
            address: "4-й пер. Кольцова 6а, Минск, Минская область 220131, Беларусь",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 538-33-00"],
                email: nil,
                website: URL(string: "https://www.instagram.com/matchpoint.minsk")
            ),
            surface: [.hard, .artificialTurf],
            type: .mixed
        ),
        Court(
            name: "Fox Tennis",
            location: CLLocationCoordinate2D(latitude: 53.941704, longitude: 27.623001),
            address: "ул. Севастопольская, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 130-70-30"],
                email: nil,
                website: URL(string: "https://fox-tennis.by/")
            ),
            surface: [.clay],
            type: .outdoor
        ),
        Court(
            name: "Белорусская Федерация Пляжного Тенниса\nКЛУБ ТЕННИСА",
            location: CLLocationCoordinate2D(latitude: 53.951425, longitude: 27.581205),
            address: "ул. Кольцова 112, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 310-55-55", "+375 17 240-48-28"],
                email: "info@tennisclub.by",
                website: URL(string: "https://tennisclub.by/")
            ),
            surface: [.hard, .artificialTurf],
            type: .mixed
        ),
        Court(
            name: "Sporting Club",
            location: CLLocationCoordinate2D(latitude: 53.954946, longitude: 27.712304),
            address: "просп. Независимости, 193, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 135 00 00"],
                email: "info@sporting.by",
                website: URL(string: "https://sporting.by/")
            ),
            surface: [.artificialTurf],
            type: .outdoor
        ),
        Court(
            name: "СДЮШОР по теннису \nСмена",
            location: CLLocationCoordinate2D(latitude: 53.899435, longitude: 27.597045),
            address: "пер. Козлова, 15, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 191-91-25", "+375 17 392-26-01", "+375 25 693-01-90", "+375 44 793-55-83"],
                email: "info@sporting.by",
                website: URL(string: "https://smenatennis.by")
            ),
            surface: [.hard],
            type: .mixed
        ),
        Court(
            name: "Республиканский центр олимпийской подготовки по теннису",
            location: CLLocationCoordinate2D(latitude: 53.923996, longitude: 27.519096),
            address: "пр-т Победителей, 63, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 343-73-28", " +375 17 226-91-82"],
                email: "center@tennisbel.by",
                website: URL(string: "https://tennisbel.by/")
            ),
            surface: [.hard, .clay],
            type: .mixed
        ),
        Court(
            name: "Городской центр олимпийского резерва по теннису",
            location: CLLocationCoordinate2D(latitude: 53.917103, longitude: 27.480722),
            address: "ул. Жудро, 40, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 604-15-87 ,+37529 675 21 45"],
                email: "reception@gcor-tennis.by",
                website: URL(string: "https://gcor-tennis.by/")
            ),
            surface: [.hard, .clay],
            type: .mixed
        ),
        Court(
            name: "Теннисный центр \n«Аква-Минск»",
            location: CLLocationCoordinate2D(latitude: 53.867268, longitude: 27.591276),
            address: "пр-т Рокоссовского, 44/2, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 685-80-35"],
                email: nil,
                website: URL(string: "https://aqua-tennisclub.by/")
            ),
            surface: [.hard, .clay],
            type: .mixed
        ),
        Court(
            name: "Falcon Club",
            location: CLLocationCoordinate2D(latitude: 53.932643, longitude: 27.510065),
            address: "пр-т Победителей, 20, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 44 770-15-72"],
                email: nil,
                website: URL(string: "https://falconclub.by/tennis-i-skvosh/")
            ),
            surface: [.hard],
            type: .indoor
        ),
        Court(
            name: "WIMC",
            location: CLLocationCoordinate2D(latitude: 53.908682, longitude: 27.620919),
            address: "ул. Столетова, 1А, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 155-01-01"],
                email: nil,
                website: URL(string: "https://www.wimc.by/")
            ),
            surface: [.hard, .grass],
            type: .mixed
        ),
        Court(
            name: "Avante",
            location: CLLocationCoordinate2D(latitude: 53.873436, longitude: 27.498473),
            address: "ул. Железнодорожная, 138, Минск, Минская область",
            contact: Court.ContactInfo(
                phoneNumbers: ["+375 29 128-30-00"],
                email: "adm@avante.by",
                website: URL(string: "https://avante.by/")
            ),
            surface: [.hard],
            type: .indoor
        )
    ]
}
