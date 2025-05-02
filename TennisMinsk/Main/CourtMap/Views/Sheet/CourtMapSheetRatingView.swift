import SwiftUI

struct CourtMapSheetRatingView: View {

    @Binding var rating: Int
    @Binding var comment: String

    var onSave: () -> Void

    @State private var initialRating: Int
    @State private var initialComment: String
    @State private var showSavedText = false

    init(rating: Binding<Int>, comment: Binding<String>, onSave: @escaping () -> Void) {
        _rating = rating
        _comment = comment
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

            TextField("Введите комментарий", text: $comment)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.bottom)

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
    CourtMapSheetRatingView(
        rating: .constant(5),
        comment: .constant("Хороший корт")
    ) { }
}
