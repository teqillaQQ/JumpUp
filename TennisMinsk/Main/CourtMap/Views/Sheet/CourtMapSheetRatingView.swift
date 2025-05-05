import SwiftUI

struct CourtMapSheetRatingView: View {

    private let scrollProxy: ScrollViewProxy
    private let onSave: () -> Void

    @Binding private var rating: Int
    @Binding private var comment: String

    @FocusState private var isTextFieldFocused: Bool

    @State private var initialRating: Int
    @State private var initialComment: String
    @State private var showSavedText = false

    init(
        rating: Binding<Int>,
        comment: Binding<String>,
        scrollProxy: ScrollViewProxy,
        onSave: @escaping () -> Void
    ) {
        _rating = rating
        _comment = comment
        self.scrollProxy = scrollProxy
        self.onSave = onSave
        _initialRating = State(initialValue: rating.wrappedValue)
        _initialComment = State(initialValue: comment.wrappedValue)
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Оцените этот корт:")
                .font(.headline)

            Picker("Оценка", selection: $rating) {
                ForEach(1..<6) { i in
                    Text("\(i)").tag(i)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.vertical)

            Text("Комментарий:")
                .font(.headline)

            ZStack(alignment: .topLeading) {
                TextEditor(text: $comment)
                    .focused($isTextFieldFocused)
                    .frame(minHeight: 100, maxHeight: 140)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5))
                    )

                if comment.isEmpty {
                    Text("Введите комментарий")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 8)
                }
            }
            .padding(.bottom)
            .id("CommentTextField")

            Button(action: {
                onSave()
                initialRating = rating
                initialComment = comment
                showSavedText = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    showSavedText = false
                }
            }) {
                Text(buttonTitle)
                    .foregroundColor(isButtonEnabled ? .blue : .gray)
                    .padding()
                    .background(Capsule().strokeBorder())
            }
            .disabled(!isButtonEnabled)
        }
        .onChange(of: isTextFieldFocused) { oldValue, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        scrollProxy.scrollTo("CommentTextField", anchor: .center)
                    }
                }
            }
        }
    }

    private var isEmptyState: Bool {
        rating == 0 && comment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var isChanged: Bool {
        rating != initialRating || comment != initialComment
    }

    private var isButtonEnabled: Bool {
        if isEmptyState {
            return true
        } else if isChanged {
            return true
        } else {
            return false
        }
    }

    private var buttonTitle: String {
        if showSavedText {
            return "Сохранено"
        } else if isEmptyState {
            return "Сохранить"
        } else {
            return "Сохранить изменения"
        }
    }
}

#Preview {
    ScrollViewReader { proxy in
        CourtMapSheetRatingView(
            rating: .constant(5),
            comment: .constant("Хороший корт"),
            scrollProxy: proxy
        ) {}
    }
}
