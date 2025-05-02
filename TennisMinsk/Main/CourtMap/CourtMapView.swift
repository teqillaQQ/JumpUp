import SwiftUI
import MapKit

struct CourtMapView: View {

    private let courts: [Court]

    @State private var cameraPosition: MapCameraPosition
    @State private var selectedCourtID: UUID?

    init(courts: [Court]) {
        self.courts = courts
        let region = Self.calculateRegion(for: courts)
        self._cameraPosition = State(initialValue: .region(region))
    }

    var body: some View {
        Map(position: $cameraPosition, selection: $selectedCourtID) {
            ForEach(courts) { court in
                Annotation(courtTitle(for: court), coordinate: court.location) {
                    CourtMapAnnotationView(isSelected: selectedCourtID == court.id)
                        .tag(court.id)
                }
            }
        }
        .mapStyle(.standard)
        .navigationTitle("Теннисные корты")
        .sheet(item: $selectedCourtID) { courtID in
            selectedCourtView(for: courtID)
        }
    }

    static func calculateRegion(for courts: [Court]) -> MKCoordinateRegion {
        guard !courts.isEmpty else {
            return Constants.defaultRegion
        }

        let latitudes = courts.map { $0.location.latitude }
        let longitudes = courts.map { $0.location.longitude }

        guard
            let minLat = latitudes.min(),
            let maxLat = latitudes.max(),
            let minLon = longitudes.min(),
            let maxLon = longitudes.max()
        else {
            return Constants.defaultRegion
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: max(0.01, (maxLat - minLat) * 1.5),
            longitudeDelta: max(0.01, (maxLon - minLon) * 1.5)
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}

// MARK: - Private methods

private extension CourtMapView {
    func courtTitle(for court: Court) -> String {
        if let rating = CourtDataService.shared.fetchCourtByID(court.persistentID)?.rating {
            return "\(court.name) ★ \(rating)"
        } else {
            return court.name
        }
    }

    @ViewBuilder
    func selectedCourtView(for id: UUID) -> some View {
        if let court = courts.first(where: { $0.id == id }) {
            CourtMapSheetView(
                court: court,
                courtSwiftData: CourtDataService.shared.fetchCourtByID(court.persistentID)
            )
            .presentationDetents([.medium, .large])
        } else {
            EmptyView()
        }
    }
}

private enum Constants {
    static let defaultRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 53.9006, longitude: 27.5590),
        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
}
