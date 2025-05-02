import SwiftData
import SwiftUI

struct MainContentView: View {

    @Environment(\.modelContext) private var modelContext

    let courts = CourtsData.courtsMinsk

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
        .onAppear {
            CourtDataService.shared.modelContext = modelContext
        }
    }
}
