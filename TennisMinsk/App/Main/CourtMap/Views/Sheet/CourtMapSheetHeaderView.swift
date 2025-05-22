import SwiftUI

struct CourtMapSheetHeaderView: View {
    let name: String
    let address: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.title2.bold())
            Text(address)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)

        Divider()
    }
}

#Preview {
    CourtMapSheetHeaderView(name: "Аванте", address: "Железнодорожная 138")
}
