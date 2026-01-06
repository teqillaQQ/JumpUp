import SwiftUI
import MapKit

import SwiftUI

struct CourtListView: View {

    let courts: [Court]

    @State private var searchQuery = ""
    @State private var selectedSurface: Court.SurfaceType? = nil
    @State private var selectedCourtType: Court.CourtType? = nil

    private var filteredCourts: [Court] {
        courts.filter { court in
            let matchesSearchQuery =
                searchQuery.isEmpty ||
                court.name.localizedCaseInsensitiveContains(searchQuery) ||
                court.address.localizedCaseInsensitiveContains(searchQuery)

            let matchesSurface = selectedSurface == nil || court.surface.contains(selectedSurface!)
            let matchesCourtType = selectedCourtType == nil || court.type == selectedCourtType!

            return matchesSearchQuery && matchesSurface && matchesCourtType
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Современный «легкий» фон
                LinearGradient(
                    colors: [
                        Color(uiColor: .systemBackground),
                        Color(uiColor: .secondarySystemBackground)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 14) {

                        header

                        filters

                        resultsRow

                        LazyVStack(spacing: 12) {
                            ForEach(filteredCourts) { court in
                                CourtCard(
                                    court: court,
                                    searchQuery: searchQuery,
                                    surfaceDescription: surfaceDescription,
                                    courtTypeDescription: courtTypeDescription
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("Корты")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Поиск по названию или адресу")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if selectedSurface != nil || selectedCourtType != nil || !searchQuery.isEmpty {
                        Button("Сброс") {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                searchQuery = ""
                                selectedSurface = nil
                                selectedCourtType = nil
                                UIApplication.shared.endEditing()
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - UI blocks

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)
                Image(systemName: "tennis.racket")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.primary)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("Список кортов")
                    .font(.title3.weight(.semibold))
                Text("Фильтруй по покрытию и типу")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var filters: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("Фильтры")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {

                    // Surface chips
                    FilterChip(
                        title: "Все покрытия",
                        isSelected: selectedSurface == nil
                    ) { selectedSurface = nil }

                    ForEach(Court.SurfaceType.allCases, id: \.self) { surface in
                        FilterChip(
                            title: surfaceDescription(surface),
                            isSelected: selectedSurface == surface
                        ) { selectedSurface = surface }
                    }

                    Divider()
                        .frame(height: 18)
                        .padding(.horizontal, 6)
                        .opacity(0.4)

                    // CourtType chips
                    FilterChip(
                        title: "Все типы",
                        isSelected: selectedCourtType == nil
                    ) { selectedCourtType = nil }

                    ForEach(Court.CourtType.allCases, id: \.self) { type in
                        FilterChip(
                            title: courtTypeDescription(type),
                            isSelected: selectedCourtType == type
                        ) { selectedCourtType = type }
                    }
                }
                .padding(.vertical, 2)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        )
    }

    private var resultsRow: some View {
        HStack {
            Text("Найдено")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\(filteredCourts.count)")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(Color.primary.opacity(0.08))
                )

            Spacer()
        }
        .padding(.horizontal, 2)
    }

    // MARK: - Text

    private func surfaceDescription(_ surface: Court.SurfaceType) -> String {
        switch surface {
        case .hard: return "Хард"
        case .clay: return "Грунт"
        case .grass: return "Трава"
        case .carpet: return "Ковер"
        case .artificialTurf: return "Искусств. трава"
        case .unknown: return "Неизвестно"
        }
    }

    private func courtTypeDescription(_ type: Court.CourtType) -> String {
        switch type {
        case .indoor: return "Крытый"
        case .outdoor: return "Открытый"
        case .mixed: return "Смешанный"
        case .unknown: return "Неизвестно"
        }
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    Capsule(style: .continuous)
                        .fill(isSelected ? Color.accentColor : Color.primary.opacity(0.08))
                )
        }
        .buttonStyle(.plain)
    }
}

private struct CourtCard: View {

    let court: Court
    let searchQuery: String
    let surfaceDescription: (Court.SurfaceType) -> String
    let courtTypeDescription: (Court.CourtType) -> String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(alignment: .top, spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color.accentColor.opacity(0.14))
                    Image(systemName: iconForCourtType(court.type))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.accentColor)
                }
                .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 6) {
                    HighlightedText(text: court.name, searchText: searchQuery)
                        .font(.headline)

                    HighlightedText(text: court.address, searchText: searchQuery)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer()
            }

            // Tags
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Tag(text: courtTypeDescription(court.type), systemImage: "door.left.hand.open")
                    if !court.surface.isEmpty {
                        Tag(text: "\(court.surface.count) покрыт.", systemImage: "square.grid.2x2")
                    }
                }

                if !court.surface.isEmpty {
                    WrapTags(items: court.surface.map(surfaceDescription)) { title in
                        Tag(text: title, systemImage: "circle.fill", compactIcon: true)
                    }
                }
            }

            // Contact actions
            HStack(spacing: 10) {
                if let phone = court.contact.phoneNumbers.first {
                    ContactButton(title: "Звонок", systemImage: "phone.fill") {
                        call(phone)
                    }
                }

                if let email = court.contact.email {
                    ContactButton(title: "Почта", systemImage: "envelope.fill") {
                        if let url = URL(string: "mailto:\(email)") {
                            UIApplication.shared.open(url)
                        }
                    }
                }

                if let website = court.contact.website {
                    ContactButton(title: "Сайт", systemImage: "safari.fill") {
                        UIApplication.shared.open(website)
                    }
                }

                Spacer()
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 6)
    }

    private func iconForCourtType(_ type: Court.CourtType) -> String {
        switch type {
        case .indoor: return "building.2.fill"
        case .outdoor: return "sun.max.fill"
        case .mixed: return "rectangle.2.swap"
        case .unknown: return "questionmark.circle.fill"
        }
    }

    private func call(_ phone: String) {
        let formatted = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if let url = URL(string: "tel://\(formatted)") {
            UIApplication.shared.open(url)
        }
    }
}

private struct ContactButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .semibold))
                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.primary.opacity(0.07))
            )
        }
        .buttonStyle(.plain)
    }
}

private struct Tag: View {
    let text: String
    let systemImage: String
    var compactIcon: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.system(size: compactIcon ? 8 : 12, weight: .semibold))
                .opacity(0.75)
            Text(text)
                .font(.caption.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            Capsule(style: .continuous)
                .fill(Color.primary.opacity(0.07))
        )
    }
}

/// Простая «обертка» для тегов в несколько строк (без сторонних библиотек).
private struct WrapTags<Data: RandomAccessCollection, Content: View>: View where Data.Element: Hashable {

    let items: Data
    let content: (Data.Element) -> Content

    init(items: Data, @ViewBuilder content: @escaping (Data.Element) -> Content) {
        self.items = items
        self.content = content
    }

    var body: some View {
        // Упрощенный wrap через adaptive grid
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 110), spacing: 8)], spacing: 8) {
            ForEach(Array(items), id: \.self) { item in
                content(item)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

#Preview {
    CourtListView(courts: CourtsData.courtsMinsk)
}
