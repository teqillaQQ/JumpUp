import SwiftUI

@MainActor
final class FAQViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var searchQuery = ""
    @Published private var faqs: [FAQ] = []

    // MARK: - Dependencies

    private let loader: FAQLoaderProtocol

    // MARK: - Computed Properties

    var filteredFaqs: [FAQ] {
        filterFaqs(with: searchQuery)
    }

    // MARK: - Init

    init(loader: FAQLoaderProtocol = FAQLoader()) {
        self.loader = loader
    }

    // MARK: - Actions

    func fetchFaqs() {
        Task {
            await loadFaqs()
        }
    }
}

// MARK: - Private Methods

private extension FAQViewModel {

    func loadFaqs() async {
        do {
            let loadedFaqs = try await loader.loadFaqs()
            self.faqs = loadedFaqs
        } catch {
            print("❌ Failed to load FAQs: \(error.localizedDescription)")
        }
    }

    func filterFaqs(with query: String) -> [FAQ] {
        guard !query.isEmpty else { return faqs }

        return faqs.filter { faq in
            faq.question.localizedCaseInsensitiveContains(query) ||
            faq.answer.localizedCaseInsensitiveContains(query)
        }
    }
}

protocol FAQLoaderProtocol {
    func loadFaqs() async throws -> [FAQ]
}

actor FAQLoader: FAQLoaderProtocol {
    func loadFaqs() async throws -> [FAQ] {
        guard let url = Bundle.main.url(forResource: "faqs", withExtension: "json") else {
            throw NSError(domain: "FAQLoader", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not find faqs.json in bundle"])
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([FAQ].self, from: data)
    }
}
