import SwiftData
import SwiftUI

struct MainContentView: View {

    @Environment(\.modelContext) private var modelContext

    let courts = CourtsData.courtsMinsk

    var body: some View {
        TabView {
            CourtMapView(courts: courts)
                .tabItem {
                    Label("Карта", systemImage: "location")
                }

            CourtListView(courts: courts)
                .tabItem {
                    Label("Список", systemImage: "list.bullet")
                }

            FAQView()
                .tabItem {
                    Label("FAQ", systemImage: "questionmark.circle")
                }
        }
        .accentColor(.blue)
        .onAppear {
            CourtDataService.shared.modelContext = modelContext
        }
    }
}

#Preview {
    MainContentView()
}
