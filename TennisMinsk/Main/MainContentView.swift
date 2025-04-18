import SwiftUI

struct MainContentView: View {

    let courts = courtsMinsk

    var body: some View {
        TabView {
            CourtMapView(courts: courts)
                .tabItem {
                    Label("Карта", systemImage: "map")
                }

            CourtListView(courts: courts)
                .tabItem {
                    Label("Список", systemImage: "list.bullet")
                }
        }
        .accentColor(.blue)
    }
}
