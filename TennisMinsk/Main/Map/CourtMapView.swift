import SwiftUI
import MapKit

struct CourtMapView: View {
    let courts: [Court]

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
                Annotation(court.name, coordinate: court.location) {
                    Image(systemName: "tennisball.fill")
                        .padding(8)
                        .background(.white)
                        .foregroundColor(.orange)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(selectedCourtID == court.id ? .blue : .clear, lineWidth: 3)
                        )
                        .tag(court.id)
                }
            }
        }
        .mapStyle(.standard)
        .navigationTitle("Теннисные корты")
        .sheet(item: $selectedCourtID) { courtID in
            if let court = courts.first(where: { $0.id == courtID }) {
                CourtDetailView(court: court)
                    .presentationDetents([.medium, .large])
            }
        }
    }

    static func calculateRegion(for courts: [Court]) -> MKCoordinateRegion {
        guard !courts.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 55.751244, longitude: 37.618423),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        }

        var minLat = courts[0].location.latitude
        var maxLat = courts[0].location.latitude
        var minLon = courts[0].location.longitude
        var maxLon = courts[0].location.longitude

        for court in courts.dropFirst() {
            minLat = min(minLat, court.location.latitude)
            maxLat = max(maxLat, court.location.latitude)
            minLon = min(minLon, court.location.longitude)
            maxLon = max(maxLon, court.location.longitude)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )

        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.5,
            longitudeDelta: (maxLon - minLon) * 1.5
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}
