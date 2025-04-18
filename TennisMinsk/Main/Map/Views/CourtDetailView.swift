import SwiftUI
import MapKit

struct CourtDetailView: View {
    let court: Court

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

                        Divider()

                        if !court.contact.phoneNumbers.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Контакты")
                                    .font(.headline)

                                ForEach(court.contact.phoneNumbers, id: \.self) { phone in
                                    ContactRowView(
                                        icon: "phone.fill",
                                        text: phone,
                                        action: { callNumber(phone: phone) }
                                    )
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
}
