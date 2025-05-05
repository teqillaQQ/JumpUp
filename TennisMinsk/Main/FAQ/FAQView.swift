import SwiftUI

struct FAQView: View {

    struct FAQ: Identifiable, Decodable {
        let id: String
        let question: String
        let answer: String
    }

    private let faqs = [
        FAQ(
            id: "0001",
            question: "Как записаться на корт?",
            answer: "Перейдите в раздел 'Карта' или 'Список', выберите нужный корт и забронируйте время."
        ),
        FAQ(
            id: "0002",
            question: "Как выбрать подходящий уровень игры?",
            answer: "Мы рекомендуем начинать с уровня 'Новичок', если вы только начинаете играть."
        )
    ]

    @State private var searchQuery = ""

    private var filteredFaqs: [FAQ] {
        faqs.filter { faq in
            let matchesSearchQuery = searchQuery.isEmpty ||
            faq.question.localizedCaseInsensitiveContains(searchQuery) ||
            faq.answer.localizedCaseInsensitiveContains(searchQuery)

            return matchesSearchQuery
        }
    }

    var body: some View {
        NavigationView {

            VStack {
                SearchBar(text: $searchQuery)
                    .padding(.bottom, 8)


                List(filteredFaqs) { faq in
                    VStack(alignment: .leading, spacing: 8) {
                        HighlightedText(text: faq.question, searchText: searchQuery)
                            .font(.headline)

                        HighlightedText(text: faq.answer, searchText: searchQuery)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 8)
                    .contentShape(Rectangle())
                }
            }
            .navigationTitle("FAQ")
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#Preview {
    FAQView()
}
