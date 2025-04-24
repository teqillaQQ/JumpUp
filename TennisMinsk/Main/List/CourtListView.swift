import SwiftUI
import MapKit

struct CourtListView: View {
    let courts: [Court]

    var body: some View {
        List(courts) { court in
            VStack(alignment: .leading, spacing: 8) {
                Text(court.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(court.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if !court.surface.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Тип покрытия:")
                            .font(.subheadline)
                            .bold()

                        ForEach(court.surface, id: \.self) { surface in
                            Text(surfaceDescription(surface))
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.top, 4)
                }

                Text("Тип корта: \(courtTypeDescription(court.type))")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .padding(.top, 4)

                if !court.contact.phoneNumbers.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Телефоны:")
                            .font(.subheadline)
                            .bold()

                        ForEach(court.contact.phoneNumbers, id: \.self) { phone in
                            Text(phone)
                                .font(.subheadline)
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    let formattedPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                                    if let url = URL(string: "tel://\(formattedPhone)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                        }
                    }
                    .padding(.top, 4)
                }

                if let email = court.contact.email {
                    HStack(spacing: 4) {
                        Text("Email:")
                            .font(.subheadline)
                            .bold()

                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let url = URL(string: "mailto:\(email)") {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    .padding(.top, 4)
                }

                if let website = court.contact.website {
                    HStack(spacing: 4) {
                        Text("Сайт:")
                            .font(.subheadline)
                            .bold()

                        Text(website.absoluteString)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                            .onTapGesture {
                                UIApplication.shared.open(website)
                            }
                    }
                    .padding(.top, 4)
                }
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Теннисные корты")
    }

    private func surfaceDescription(_ surface: Court.SurfaceType) -> String {
        switch surface {
        case .hard:
            return "Твердое"
        case .clay:
            return "Глиняное"
        case .grass:
            return "Травяное"
        case .carpet:
            return "Ковровое"
        case .artificialTurf:
            return "Искусственный газон"
        case .unknown:
            return "Неизвестно"
        }
    }

    private func courtTypeDescription(_ type: Court.CourtType) -> String {
        switch type {
        case .indoor:
            return "Закрытый"
        case .outdoor:
            return "Открытый"
        case .mixed:
            return "Смешанный"
        case .unknown:
            return "Неизвестно"
        }
    }
}
