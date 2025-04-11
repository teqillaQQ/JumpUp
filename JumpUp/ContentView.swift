import SwiftUI

struct ContentView: View {
    let courts = testCourts

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
