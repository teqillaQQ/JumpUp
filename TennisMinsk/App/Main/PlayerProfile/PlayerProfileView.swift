import SwiftUI
import PhotosUI

struct PlayerProfileView: View {

    @StateObject private var viewModel = PlayerProfileViewModel()

    @State private var isShowingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {

                Spacer()

                if let image = viewModel.avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 140, height: 140)
                        .overlay(
                            Text("Выбрать фото")
                                .foregroundColor(.blue)
                        )
                        .onTapGesture {
                            isShowingPhotoPicker = true
                        }
                }

                TextField("Имя", text: $viewModel.name)
                    .multilineTextAlignment(.center)
                    .font(.title2)
                    .frame(maxWidth: 300)
                    .textFieldStyle(.roundedBorder)

                Spacer()
            }
            .hideKeyboardOnTap()
            .padding()
            .navigationTitle("Профиль игрока")
            .onAppear {
                viewModel.loadProfile()
            }
            .photosPicker(isPresented: $isShowingPhotoPicker, selection: $selectedPhotoItem, matching: .images)
            .onChange(of: selectedPhotoItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        await MainActor.run {
                            viewModel.avatarImage = uiImage
                        }
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                Button(action: {
                    viewModel.saveProfile()
                }) {
                    Text("Сохранить")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.name.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(viewModel.name.isEmpty)
                .padding(.bottom, 8)
            }
        }
    }
}
