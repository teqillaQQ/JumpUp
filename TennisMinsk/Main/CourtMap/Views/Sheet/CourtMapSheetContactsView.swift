import SwiftUI

struct CourtMapSheetContactsInfoView: View {

    let contactInfo: Court.ContactInfo

    let onCall: (String) -> Void
    let onEmail: (String) -> Void
    let onOpenWebsite: (URL) -> Void

    @State private var showAllPhones = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if contactInfo.phoneNumbers.isNotEmpty {
                Text("Контакты")
                    .font(.headline)

                let phonesToShow = showAllPhones ? contactInfo.phoneNumbers : [contactInfo.phoneNumbers.first].compactMap { $0 }

                ForEach(phonesToShow, id: \.self) { phone in
                    ContactRowView(
                        icon: "phone.fill",
                        text: phone,
                        action: { onCall(phone) }
                    )
                }

                if contactInfo.phoneNumbers.count > 1 {
                    Button(action: {
                        withAnimation {
                            showAllPhones.toggle()
                        }
                    }) {
                        Text(showAllPhones ? "Скрыть номера" : "Показать все номера")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.top, 4)
                    }
                }
            }

            if let email = contactInfo.email {
                ContactRowView(
                    icon: "envelope.fill",
                    text: email,
                    action: { onEmail(email) }
                )
            }

            if let website = contactInfo.website {
                ContactRowView(
                    icon: "globe",
                    text: website.absoluteString,
                    action: { onOpenWebsite(website) }
                )
            }
        }

        Divider()
    }
}

#Preview {
    CourtMapSheetContactsInfoView(
        contactInfo: .init(
            phoneNumbers: ["+375 29 555 66 77", "+375 29 876 11 33"],
            email: "example@example.com",
            website: URL(string: "example.com")
        ),
        onCall: { _ in },
        onEmail: { _ in },
        onOpenWebsite: { _ in }
    )
}
