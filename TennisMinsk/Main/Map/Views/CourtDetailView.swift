import SwiftUI
import MapKit

struct CourtDetailView: View {

    let court: Court

    @State private var showAllPhones = false

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(court.name)
                                .font(.title2.bold())

                            Text(court.address)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)

                        Divider()

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Характеристики")
                                .font(.headline)

                            HStack {
                                Image(systemName: "square.stack.3d.up.fill")
                                Text("Тип корта: \(courtTypeText(court.type))")
                            }

                            HStack(alignment: .top) {
                                Image(systemName: "circle.grid.2x2.fill")
                                Text("Покрытие: ") +
                                Text(court.surface.map { surfaceText($0) }.joined(separator: ", "))
                            }
                        }

                        Divider()

                        if !court.contact.phoneNumbers.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Контакты")
                                    .font(.headline)

                                let phonesToShow = showAllPhones ? court.contact.phoneNumbers : [court.contact.phoneNumbers.first].compactMap { $0 }

                                ForEach(phonesToShow, id: \.self) { phone in
                                    ContactRowView(
                                        icon: "phone.fill",
                                        text: phone,
                                        action: { callNumber(phone: phone) }
                                    )
                                }

                                if court.contact.phoneNumbers.count > 1 {
                                    Button(action: {
                                        withAnimation {
                                            showAllPhones.toggle()
                                        }
                                    }) {
                                        Text(showAllPhones ? "Скрыть номера" : "Показать все номера")
                                            .font(.subheadline)
                                            .foregroundColor(.blue)
                                            .padding(.top, 4)
                                    }
                                }
                            }
                        }

                        if let email = court.contact.email {
                            ContactRowView(
                                icon: "envelope.fill",
                                text: email,
                                action: { sendEmail(to: email) }
                            )
                        }

                        if let website = court.contact.website {
                            ContactRowView(
                                icon: "globe",
                                text: website.absoluteString,
                                action: { UIApplication.shared.open(website) }
                            )
                        }

                        Spacer()
                            .frame(height: 60)
                    }
                    .padding()
                    .padding(.bottom, 60)
                }

                Button(action: {
                    openInMaps(coordinate: court.location)
                }) {
                    Label("Построить маршрут", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                .background(Color(.systemBackground))
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func callNumber(phone: String) {
        let formattedPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(formattedPhone)") {
            UIApplication.shared.open(url)
        }
    }

    private func sendEmail(to email: String) {
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }

    private func openInMaps(coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = court.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    private func surfaceText(_ surface: Court.SurfaceType) -> String {
        switch surface {
        case .hard: return "Хард"
        case .clay: return "Грунт"
        case .grass: return "Трава"
        case .carpet: return "Ковёр"
        case .artificialTurf: return "Искусственная трава"
        case .unknown: return "Неизвестно"
        }
    }

    private func courtTypeText(_ type: Court.CourtType) -> String {
        switch type {
        case .indoor: return "Крытый"
        case .outdoor: return "Открытый"
        case .mixed: return "Крытый и открытый"
        case .unknown: return "Неизвестно"
        }
    }
}
