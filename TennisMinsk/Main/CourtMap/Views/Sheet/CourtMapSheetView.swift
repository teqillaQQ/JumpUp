import SwiftUI
import MapKit

struct CourtMapSheetView: View {

    private let court: Court

    @State private var rating: Int
    @State private var comment: String

    init(court: Court, courtSwiftData: CourtSwiftData? = nil) {
        self.court = court
        rating = courtSwiftData?.rating ?? 0
        comment = courtSwiftData?.comment ?? ""
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            CourtMapSheetHeaderView(name: court.name, address: court.address)
                            CourtMapSheetCharacteristicsView(type: court.type, surface: court.surface)
                            CourtMapSheetContactsInfoView(
                                contactInfo: court.contact,
                                onCall: callNumber,
                                onEmail: sendEmail,
                                onOpenWebsite: openWebsite
                            )
                            CourtMapSheetRatingView(
                                rating: $rating,
                                comment: $comment,
                                scrollProxy: proxy,
                                onSave: saveRatingAndComment
                            )
                        }
                        .padding()
                        .padding(.bottom, 60)

                        CourtMapSheetRouteButtonView {
                            openInMaps(coordinate: court.location)
                        }
                    }
                    .hideKeyboardOnTap()
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }

    private func saveRatingAndComment() {
        CourtDataService.shared.saveOrUpdateCourt(
            persistentID: court.persistentID,
            rating: rating,
            comment: comment
        )
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

    private func openWebsite(url: URL) {
        UIApplication.shared.open(url)
    }

    private func openInMaps(coordinate: CLLocationCoordinate2D) {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = court.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

#Preview {
    CourtMapSheetView(
        court: CourtsData.courtsMinsk[2],
        courtSwiftData: nil
    )
}
