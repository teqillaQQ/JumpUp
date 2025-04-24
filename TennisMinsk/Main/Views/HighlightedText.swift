import SwiftUI

struct HighlightedText: View {
    let text: String
    let searchText: String

    var body: some View {
        Text(makeHighlightedText())
    }

    private func makeHighlightedText() -> AttributedString {
        var attributed = AttributedString(text)
        guard !searchText.isEmpty else { return attributed }

        let lowercasedText = text.lowercased()
        let lowercasedSearch = searchText.lowercased()

        var searchRange = lowercasedText.startIndex..<lowercasedText.endIndex

        while let range = lowercasedText.range(of: lowercasedSearch, options: [], range: searchRange) {
            let nsRange = NSRange(range, in: text)
            
            if let stringRange = Range(nsRange, in: attributed) {
                attributed[stringRange].foregroundColor = .red
                attributed[stringRange].font = .headline.bold()
            }

            searchRange = range.upperBound..<lowercasedText.endIndex
        }

        return attributed
    }
}
