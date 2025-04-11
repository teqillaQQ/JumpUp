import SwiftUI

struct CourtListView: View {
    let courts: [Court]

    var body: some View {
        List(courts) { court in
            VStack(alignment: .leading, spacing: 8) {
                Text(court.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(court.address)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("Рейтинг: \(court.rating, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.vertical, 8)
        }
        .navigationTitle("Теннисные корты")
    }
}

struct CourtListView_Previews: PreviewProvider {
    static var previews: some View {
        CourtListView(courts: testCourts)
    }
}
