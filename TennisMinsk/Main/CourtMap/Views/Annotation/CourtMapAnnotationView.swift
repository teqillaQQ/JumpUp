import SwiftUI

struct CourtMapAnnotationView: View {
    let isSelected: Bool

    var body: some View {
        Image(systemName: "tennisball.fill")
            .padding(6)
            .background(.white)
            .foregroundColor(.orange)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(isSelected ? .blue : .clear, lineWidth: 3)
            )
            .shadow(radius: 3)
            .scaleEffect(isSelected ? 1.3 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

#Preview {
    CourtMapAnnotationView(isSelected: true)
}
