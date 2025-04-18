import SwiftUI

struct ContactRowView: View {
    
    let icon: String
    let text: String
    let action: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
            Text(text)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .onTapGesture(perform: action)
        .foregroundColor(.blue)
    }
}
