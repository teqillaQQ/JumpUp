import SwiftUI
import MapKit

struct CourtListView: View {

    let courts: [Court]

    @State private var searchQuery = ""
    @State private var selectedSurface: Court.SurfaceType? = nil
    @State private var selectedCourtType: Court.CourtType? = nil

    var filteredCourts: [Court] {
        courts.filter { court in
            let matchesSearchQuery = searchQuery.isEmpty ||
            court.name.localizedCaseInsensitiveContains(searchQuery) ||
            court.address.localizedCaseInsensitiveContains(searchQuery)

            let matchesSurface = selectedSurface == nil || court.surface.contains(selectedSurface!)
            let matchesCourtType = selectedCourtType == nil || court.type == selectedCourtType!

            return matchesSearchQuery && matchesSurface && matchesCourtType
        }
    }

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }

            VStack {
                SearchBar(text: $searchQuery)

                HStack {
                    Picker("Тип покрытия", selection: $selectedSurface) {
                        Text("Все типы").tag(Court.SurfaceType?.none)
                        ForEach(Court.SurfaceType.allCases, id: \.self) { surface in
                            Text(surfaceDescription(surface)).tag(surface as Court.SurfaceType?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()

                    Picker("Тип корта", selection: $selectedCourtType) {
                        Text("Все типы").tag(Court.CourtType?.none)
                        ForEach(Court.CourtType.allCases, id: \.self) { type in
                            Text(courtTypeDescription(type)).tag(type as Court.CourtType?)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                }

                List(filteredCourts) { court in
                    VStack(alignment: .leading, spacing: 8) {
                        HighlightedText(text: court.name, searchText: searchQuery)
                            .font(.headline)

                        HighlightedText(text: court.address, searchText: searchQuery)
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if !court.surface.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Тип покрытия:")
                                    .font(.subheadline)
                                    .bold()

                                ForEach(court.surface, id: \.self) { surface in
                                    Text(surfaceDescription(surface))
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding(.top, 4)
                        }

                        Text("Тип корта: \(courtTypeDescription(court.type))")
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.top, 4)

                        if !court.contact.phoneNumbers.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Телефоны:")
                                    .font(.subheadline)
                                    .bold()

                                ForEach(court.contact.phoneNumbers, id: \.self) { phone in
                                    Text(phone)
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                        .onTapGesture {
                                            let formattedPhone = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                                            if let url = URL(string: "tel://\(formattedPhone)") {
                                                UIApplication.shared.open(url)
                                            }
                                        }
                                }
                            }
                            .padding(.top, 4)
                        }

                        if let email = court.contact.email {
                            HStack(spacing: 4) {
                                Text("Email:")
                                    .font(.subheadline)
                                    .bold()

                                Text(email)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .onTapGesture {
                                        if let url = URL(string: "mailto:\(email)") {
                                            UIApplication.shared.open(url)
                                        }
                                    }
                            }
                            .padding(.top, 4)
                        }

                        if let website = court.contact.website {
                            HStack(spacing: 4) {
                                Text("Сайт:")
                                    .font(.subheadline)
                                    .bold()

                                Text(website.absoluteString)
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                    .lineLimit(1)
                                    .onTapGesture {
                                        UIApplication.shared.open(website)
                                    }
                            }
                            .padding(.top, 4)
                        }
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                }
            }
            .navigationTitle("Теннисные корты")
        }
    }

    private func surfaceDescription(_ surface: Court.SurfaceType) -> String {
        switch surface {
        case .hard: return "хард"
        case .clay: return "грунт"
        case .grass: return "трава"
        case .carpet: return "ковер"
        case .artificialTurf: return "искусственная трава"
        case .unknown: return "неизвестно"
        }
    }

    private func courtTypeDescription(_ type: Court.CourtType) -> String {
        switch type {
        case .indoor: return "крытый"
        case .outdoor: return "открытый"
        case .mixed: return "крытый и открытый"
        case .unknown: return "неизвестно"
        }
    }
}
