import SwiftUI

struct FAQView: View {

    @StateObject private var viewModel = FAQViewModel()

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchQuery)
                    .padding(.bottom, 8)

                List(viewModel.filteredFaqs) { faq in
                    VStack(alignment: .leading, spacing: 8) {
                        HighlightedText(text: faq.question, searchText: viewModel.searchQuery)
                            .font(.headline)

                        HighlightedText(text: faq.answer, searchText: viewModel.searchQuery)
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
        .onAppear {
            viewModel.fetchFaqs()
        }
    }
}

#Preview {
    FAQView()
}
