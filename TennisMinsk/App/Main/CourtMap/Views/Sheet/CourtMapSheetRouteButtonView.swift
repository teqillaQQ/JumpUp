import SwiftUI

struct CourtMapSheetRouteButtonView: View {

    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("Построить маршрут", systemImage: "arrow.triangle.turn.up.right.diamond.fill")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
    }
}

#Preview {
    CourtMapSheetRouteButtonView() {}
}
