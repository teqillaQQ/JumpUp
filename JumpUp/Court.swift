import Foundation
import MapKit

struct Court: Identifiable {
    let id = UUID()
    let name: String
    let location: CLLocationCoordinate2D
    let address: String
    let rating: Double
}

let testCourts: [Court] = [
    Court(name: "Central Park Tennis Center",
          location: CLLocationCoordinate2D(latitude: 40.7829, longitude: -73.9654),
          address: "Central Park, New York, NY",
          rating: 4.5),
    Court(name: "USTA Billie Jean King National Tennis Center",
          location: CLLocationCoordinate2D(latitude: 40.7505, longitude: -73.8456),
          address: "Flushing Meadows, Queens, NY",
          rating: 4.8)
]
