import SwiftUI
import PhotosUI

import SwiftUI
import PhotosUI

struct PlayerProfileView: View {

    // MARK: - UserDefaults via AppStorage
    @AppStorage("profile.name") private var name: String = ""
    @AppStorage("profile.city") private var city: String = ""
    @AppStorage("profile.about") private var about: String = ""
    @AppStorage("profile.notificationsEnabled") private var notificationsEnabled: Bool = true

    // Enums stored as rawValue (String)
    @AppStorage("profile.level") private var levelRaw: String = PlayerLevel.intermediate.rawValue
    @AppStorage("profile.preferredHand") private var handRaw: String = PreferredHand.right.rawValue

    // Avatar stored as Data (JPEG)
    @AppStorage("profile.avatarData") private var avatarData: Data = Data()

    // Onboarding flag (в App это же поле управляет показом онбординга)
    @AppStorage("onboarding.completed") private var onboardingCompleted: Bool = false

    // MARK: - UI State
    @State private var isShowingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showDeleteConfirm = false

    // Keyboard dismiss
    @FocusState private var isKeyboardFocused: Bool

    // Support call
    private let supportPhoneNumberE164 = "+375296676778"

    // MARK: - Computed bindings
    private var levelBinding: Binding<PlayerLevel> {
        Binding(
            get: { PlayerLevel(rawValue: levelRaw) ?? .intermediate },
            set: { levelRaw = $0.rawValue }
        )
    }

    private var handBinding: Binding<PreferredHand> {
        Binding(
            get: { PreferredHand(rawValue: handRaw) ?? .right },
            set: { handRaw = $0.rawValue }
        )
    }

    private var avatarImage: UIImage? {
        guard !avatarData.isEmpty else { return nil }
        return UIImage(data: avatarData)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundLayer

                ScrollView {
                    VStack(spacing: 16) {
                        headerSection
                        mainInfoSection
                        preferencesSection
                        supportSection
                        dangerSection
                    }
                    .padding()
                }
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.large)

            // Hide keyboard on tap anywhere
            .contentShape(Rectangle())
            .onTapGesture { isKeyboardFocused = false }

            .photosPicker(
                isPresented: $isShowingPhotoPicker,
                selection: $selectedPhotoItem,
                matching: .images
            )
            .onChange(of: selectedPhotoItem) { handlePhotoChange() }

            .confirmationDialog("Удалить профиль?", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
                deleteButtons
            } message: {
                Text("Данные профиля будут удалены безвозвратно.")
            }
        }
    }
}

// MARK: - Sections
private extension PlayerProfileView {

    var backgroundLayer: some View {
        LinearGradient(
            colors: [Color(uiColor: .systemBackground), Color(uiColor: .secondarySystemBackground)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    var headerSection: some View {
        VStack(spacing: 12) {
            avatarView

            VStack(spacing: 4) {
                TextField("Ваше имя", text: $name)
                    .focused($isKeyboardFocused)
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }

    var avatarView: some View {
        Button { isShowingPhotoPicker = true } label: {
            ZStack(alignment: .bottomTrailing) {
                if let image = avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 60))
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 110, height: 110)
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.accentColor.opacity(0.2), lineWidth: 2))
        }
        .buttonStyle(.plain)
    }

    var mainInfoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Информация", systemImage: "info.circle")
                .font(.headline)

            TextField("Город", text: $city)
                .focused($isKeyboardFocused)
                .padding()
                .background(Color.primary.opacity(0.05))
                .cornerRadius(12)

            TextField("О себе", text: $about, axis: .vertical)
                .focused($isKeyboardFocused)
                .lineLimit(3...5)
                .padding()
                .background(Color.primary.opacity(0.05))
                .cornerRadius(12)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }

    var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Теннис", systemImage: "figure.tennis")
                .font(.headline)

            Picker("Уровень игры", selection: levelBinding) {
                ForEach(PlayerLevel.allCases, id: \.self) { Text($0.title).tag($0) }
            }
            .pickerStyle(.menu)

            Divider()

            Picker("Рабочая рука", selection: handBinding) {
                ForEach(PreferredHand.allCases, id: \.self) { Text($0.title).tag($0) }
            }
            .pickerStyle(.menu)

            Divider()

            Toggle("Уведомления", isOn: $notificationsEnabled)
                .tint(.accentColor)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 24).fill(.ultraThinMaterial))
    }

    var supportSection: some View {
        Button {
            callSupport()
        } label: {
            Label("Позвонить в поддержку", systemImage: "phone.fill")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor.opacity(0.12))
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }

    var dangerSection: some View {
        Button(role: .destructive) { showDeleteConfirm = true } label: {
            Label("Удалить профиль", systemImage: "trash")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(16)
        }
    }

    @ViewBuilder
    var deleteButtons: some View {
        Button("Удалить", role: .destructive) {
            deleteProfileAndShowOnboarding()
        }
        Button("Отмена", role: .cancel) {}
    }
}

// MARK: - Logic
private extension PlayerProfileView {

    func handlePhotoChange() {
        Task {
            guard let item = selectedPhotoItem,
                  let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data)
            else { return }

            if let jpeg = image.jpegData(compressionQuality: 0.8) {
                avatarData = jpeg
            }
        }
    }

    func callSupport() {
        isKeyboardFocused = false

        let digits = supportPhoneNumberE164
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")

        guard let url = URL(string: "tel://\(digits)") else { return }
        UIApplication.shared.open(url)
    }

    /// Полное удаление данных профиля + возврат к онбордингу
    func deleteProfileAndShowOnboarding() {
        isKeyboardFocused = false

        // 1) Чистим всё, что относится к профилю
        name = ""
        city = ""
        about = ""
        levelRaw = PlayerLevel.intermediate.rawValue
        handRaw = PreferredHand.right.rawValue
        notificationsEnabled = true
        avatarData = Data()

        // 2) Сбрасываем онбординг (приложение снова покажет его)
        onboardingCompleted = false
    }
}

// MARK: - Supporting Enums
enum PlayerLevel: String, CaseIterable {
    case beginner, intermediate, advanced, pro

    var title: String {
        switch self {
        case .beginner: return "Новичок"
        case .intermediate: return "Средний"
        case .advanced: return "Продвинутый"
        case .pro: return "Профи"
        }
    }
}

enum PreferredHand: String, CaseIterable {
    case left, right
    var title: String { self == .left ? "Левша" : "Правша" }
}
