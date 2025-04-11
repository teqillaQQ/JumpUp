import SwiftUI
import MapKit

struct CourtMapView: View {
    let courts: [Court]
    @State private var region: MKCoordinateRegion

    // Инициализация региона
    init(courts: [Court]) {
        self.courts = courts
        self._region = State(initialValue: Self.calculateRegion(for: courts))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: courts) { court in
            MapPin(coordinate: court.location, tint: .red)
        }
        .navigationTitle("Карта кортов")
    }

    // Вычисление региона карты
    static func calculateRegion(for courts: [Court]) -> MKCoordinateRegion {
        guard !courts.isEmpty else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 180, longitudeDelta: 360)
            )
        }

        var minLat = courts[0].location.latitude
        var maxLat = courts[0].location.latitude
        var minLon = courts[0].location.longitude
        var maxLon = courts[0].location.longitude

        for court in courts {
            let lat = court.location.latitude
            let lon = court.location.longitude
            minLat = min(minLat, lat)
            maxLat = max(maxLat, lat)
            minLon = min(minLon, lon)
            maxLon = max(maxLon, lon)
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: (maxLat - minLat) * 1.1,
            longitudeDelta: (maxLon - minLon) * 1.1
        )

        return MKCoordinateRegion(center: center, span: span)
    }
}

struct CourtMapView_Previews: PreviewProvider {
    static var previews: some View {
        CourtMapView(courts: testCourts)
    }
}
