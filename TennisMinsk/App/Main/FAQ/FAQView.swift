import SwiftUI

struct FAQView: View {

    @StateObject private var viewModel = FAQViewModel()

    @State private var expandedIDs = Set<FAQ.ID>()

    var body: some View {
        NavigationStack {
            ZStack {
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

                        resultsRow

                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.filteredFaqs) { faq in
                                FAQCard(
                                    faq: faq,
                                    searchQuery: viewModel.searchQuery,
                                    isExpanded: expandedIDs.contains(faq.id),
                                    toggle: {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                            if expandedIDs.contains(faq.id) {
                                                expandedIDs.remove(faq.id)
                                            } else {
                                                expandedIDs.insert(faq.id)
                                            }
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                }
            }
            .navigationTitle("FAQ")
            .navigationBarTitleDisplayMode(.large)
            .searchable(
                text: $viewModel.searchQuery,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Поиск по вопросам"
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.searchQuery.isEmpty || !expandedIDs.isEmpty {
                        Button("Сброс") {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                                viewModel.searchQuery = ""
                                expandedIDs.removeAll()
                                UIApplication.shared.endEditing()
                            }
                        }
                    }
                }
            }
            .onTapGesture { UIApplication.shared.endEditing() }
            .task {
                viewModel.fetchFaqs()
            }
        }
    }

    // MARK: - UI blocks

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.ultraThinMaterial)

                Image(systemName: "questionmark.bubble.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.accentColor)
            }
            .frame(width: 44, height: 44)

            VStack(alignment: .leading, spacing: 2) {
                Text("Помощь и ответы")
                    .font(.title3.weight(.semibold))
                Text("Найди вопрос или раскрой карточку")
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

    private var resultsRow: some View {
        HStack {
            Text("Найдено")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text("\(viewModel.filteredFaqs.count)")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Capsule().fill(Color.primary.opacity(0.08)))

            Spacer()

            if !expandedIDs.isEmpty {
                Button("Свернуть всё") {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                        expandedIDs.removeAll()
                    }
                }
                .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal, 2)
    }
}

// MARK: - Components

private struct FAQCard: View {

    let faq: FAQ
    let searchQuery: String
    let isExpanded: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            VStack(alignment: .leading, spacing: 10) {

                HStack(alignment: .top, spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color.accentColor.opacity(0.14))
                        Image(systemName: "questionmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.accentColor)
                    }
                    .frame(width: 34, height: 34)

                    VStack(alignment: .leading, spacing: 6) {
                        HighlightedText(text: faq.question, searchText: searchQuery)
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .multilineTextAlignment(.leading)

                        if isExpanded {
                            HighlightedText(text: faq.answer, searchText: searchQuery)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                                .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }

                    Spacer(minLength: 0)

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
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
        .buttonStyle(.plain)
    }
}

private struct SmallPill: View {
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
            Text(title)
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.secondary)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.primary.opacity(0.06))
        )
    }
}

#Preview {
    FAQView()
}
