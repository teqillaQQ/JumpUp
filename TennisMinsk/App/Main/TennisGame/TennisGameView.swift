//
//  TennisGameView.swift
//  TennisMinsk
//
//  Created by Uladzislau Simanau on 6.01.26.
//

import SwiftUI
import EventKit

// MARK: - Model (UserDefaults storage)
struct TennisGame: Identifiable, Codable, Equatable {
    enum Status: String, Codable, CaseIterable { case planned, played }

    var id: UUID = UUID()
    var status: Status

    // Common
    var title: String                 // например: "Игра с Антоном"
    var courtName: String
    var city: String
    var date: Date
    var notes: String

    // Planned extras
    var opponentName: String
    var format: MatchFormat
    var surface: Surface
    var isIndoor: Bool

    // Played extras
    var myScore: Int
    var opponentScore: Int
    var durationMinutes: Int
    var result: Result

    enum MatchFormat: String, Codable, CaseIterable {
        case friendly, training, tournament
        var title: String {
            switch self {
            case .friendly: return "Дружеская"
            case .training: return "Тренировка"
            case .tournament: return "Турнир"
            }
        }
    }

    enum Surface: String, Codable, CaseIterable {
        case hard, clay, grass, carpet, other
        var title: String {
            switch self {
            case .hard: return "Хард"
            case .clay: return "Грунт"
            case .grass: return "Трава"
            case .carpet: return "Ковёр"
            case .other: return "Другое"
            }
        }
    }

    enum Result: String, Codable, CaseIterable {
        case win, loss, draw
        var title: String {
            switch self {
            case .win: return "Победа"
            case .loss: return "Поражение"
            case .draw: return "Ничья"
            }
        }
    }

    static func makePlanned() -> TennisGame {
        .init(
            status: .planned,
            title: "Планируемая игра",
            courtName: "",
            city: "Минск",
            date: Date().addingTimeInterval(60 * 60 * 24),
            notes: "",
            opponentName: "",
            format: .friendly,
            surface: .hard,
            isIndoor: false,
            myScore: 0,
            opponentScore: 0,
            durationMinutes: 90,
            result: .win
        )
    }

    static func makePlayed() -> TennisGame {
        .init(
            status: .played,
            title: "Сыгранная игра",
            courtName: "",
            city: "Минск",
            date: Date(),
            notes: "",
            opponentName: "",
            format: .training,
            surface: .hard,
            isIndoor: false,
            myScore: 6,
            opponentScore: 4,
            durationMinutes: 90,
            result: .win
        )
    }
}

// MARK: - UserDefaults Store
final class TennisGamesStore: ObservableObject {
    @Published var games: [TennisGame] = [] {
        didSet { save() }
    }

    private let key = "games.v1"

    init() { load() }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            games = []
            return
        }
        do {
            games = try JSONDecoder().decode([TennisGame].self, from: data)
        } catch {
            games = []
        }
    }

    func save() {
        do {
            let data = try JSONEncoder().encode(games)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            // silently ignore
        }
    }

    func upsert(_ game: TennisGame) {
        if let i = games.firstIndex(where: { $0.id == game.id }) {
            games[i] = game
        } else {
            games.insert(game, at: 0)
        }
    }

    func delete(_ game: TennisGame) {
        games.removeAll { $0.id == game.id }
    }

    func clearAll() {
        games = []
        UserDefaults.standard.removeObject(forKey: key)
    }
}

// MARK: - Main Screen
struct GamesView: View {
    @StateObject private var store = TennisGamesStore()

    enum Tab: Int, CaseIterable {
        case planned, played
        var title: String { self == .planned ? "Планируемые" : "Сыгранные" }
        var icon: String { self == .planned ? "calendar" : "clock.arrow.circlepath" }
    }

    @State private var tab: Tab = .planned
    @State private var showNewGameSheet = false
    @State private var editingGame: TennisGame?
    @State private var showCalendarAlert = false
    @State private var calendarAlertTitle = ""
    @State private var calendarAlertMessage = ""

    // Style
    private let cardCorner: CGFloat = 22

    var body: some View {
        NavigationStack {
            ZStack {
                backgroundLayer

                ScrollView {
                    VStack(spacing: 14) {
                        headerPill

                        if filteredGames.isEmpty {
                            emptyState
                                .padding(.top, 10)
                        } else {
                            VStack(spacing: 12) {
                                ForEach(filteredGames) { game in
                                    gameCard(game)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Игры")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewGameSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .sheet(isPresented: $showNewGameSheet) {
                GameEditorView(
                    initial: tab == .planned ? .makePlanned() : .makePlayed(),
                    mode: .create,
                    onSave: { store.upsert($0) }
                )
                .presentationDetents([.large])
            }
            .sheet(item: $editingGame) { game in
                GameEditorView(
                    initial: game,
                    mode: .edit,
                    onSave: { store.upsert($0) }
                )
                .presentationDetents([.large])
            }
        }
        .alert(calendarAlertTitle, isPresented: $showCalendarAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(calendarAlertMessage)
        }
    }

    private var filteredGames: [TennisGame] {
        store.games
            .filter { tab == .planned ? $0.status == .planned : $0.status == .played }
            .sorted { $0.date > $1.date }
    }
}

// MARK: - UI building blocks
private extension GamesView {

    var backgroundLayer: some View {
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

            // subtle “court-ish” overlay
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .stroke(Color.primary.opacity(0.035), lineWidth: 1)
                .padding(18)
                .blur(radius: 0)
        }
    }

    var headerPill: some View {
        VStack(spacing: 10) {
            Picker("", selection: $tab) {
                ForEach(Tab.allCases, id: \.self) { t in
                    Label(t.title, systemImage: t.icon).tag(t)
                }
            }
            .pickerStyle(.segmented)

            Text(tab == .planned
                 ? "Планируй игры, чтобы ничего не забыть — можно добавить в календарь."
                 : "Записывай результат и заметки — так видно прогресс.")
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: cardCorner, style: .continuous))
    }

    var emptyState: some View {
        VStack(spacing: 10) {
            Image(systemName: tab == .planned ? "calendar.badge.plus" : "figure.tennis")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.secondary)

            Text(tab == .planned ? "Нет планируемых игр" : "Нет сыгранных игр")
                .font(.headline)

            Text(tab == .planned
                 ? "Нажми +, чтобы запланировать матч."
                 : "Нажми +, чтобы добавить сыгранную игру.")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: cardCorner, style: .continuous))
    }

    func gameCard(_ game: TennisGame) -> some View {
        Button {
            editingGame = game
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(game.title.isEmpty ? "Игра" : game.title)
                            .font(.headline)

                        Text("\(game.courtName.isEmpty ? "Корт не указан" : game.courtName) • \(game.city)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    statusBadge(game)
                }

                HStack(spacing: 12) {
                    Label(game.date.formatted(date: .abbreviated, time: .shortened), systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Label(game.format.title, systemImage: "flag.checkered")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Label(game.surface.title + (game.isIndoor ? " • зал" : " • улица"), systemImage: "circle.grid.cross")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                if game.status == .played {
                    HStack(spacing: 10) {
                        Text("Счёт \(game.myScore):\(game.opponentScore)")
                            .font(.subheadline.weight(.semibold))
                        Text(game.result.title)
                            .font(.subheadline)
                            .foregroundStyle(game.result == .win ? .green : (game.result == .loss ? .red : .secondary))
                        Spacer()
                        Text("\(game.durationMinutes) мин")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                } else {
                    HStack(spacing: 10) {
                        if !game.opponentName.isEmpty {
                            Text("Соперник: \(game.opponentName)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        } else {
                            Text("Соперник не указан")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            addPlannedGameToCalendar(game)
                        } label: {
                            Label("В календарь", systemImage: "calendar.badge.plus")
                                .font(.caption.weight(.semibold))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 10)
                                .background(Color.accentColor.opacity(0.14))
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !game.notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Text(game.notes)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }
            .padding(16)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cardCorner, style: .continuous))
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button("Редактировать") { editingGame = game }
            Button(role: .destructive) {
                store.delete(game)
            } label: {
                Label("Удалить", systemImage: "trash")
            }
        }
    }

    func statusBadge(_ game: TennisGame) -> some View {
        let text = game.status == .planned ? "План" : "Сыграно"
        let color: Color = game.status == .planned ? .blue : .green

        return Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(color)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(color.opacity(0.12))
            .clipShape(Capsule())
    }
}

private extension GamesView {
    func addPlannedGameToCalendar(_ game: TennisGame) {
        guard game.status == .planned else { return }

        let eventStore = EKEventStore()

        let request: (@escaping (Bool) -> Void) -> Void = { completion in
            if #available(iOS 17.0, *) {
                eventStore.requestFullAccessToEvents { granted, _ in
                    completion(granted)
                }
            } else {
                eventStore.requestAccess(to: .event) { granted, _ in
                    completion(granted)
                }
            }
        }

        request { granted in
            guard granted else {
                DispatchQueue.main.async {
                    calendarAlertTitle = "Нет доступа к календарю"
                    calendarAlertMessage = "Разреши доступ в Настройки → Конфиденциальность → Календари."
                    showCalendarAlert = true
                }
                return
            }

            let event = EKEvent(eventStore: eventStore)
            event.title = game.title.isEmpty ? "Теннис" : game.title

            let court = game.courtName.trimmingCharacters(in: .whitespacesAndNewlines)
            let city  = game.city.trimmingCharacters(in: .whitespacesAndNewlines)

            var parts: [String] = []
            if !court.isEmpty { parts.append(court) }
            if !city.isEmpty  { parts.append(city) }
            event.location = parts.isEmpty ? nil : parts.joined(separator: ", ")

            let start = game.date
            let minutes = max(30, game.durationMinutes == 0 ? 90 : game.durationMinutes)
            let end = start.addingTimeInterval(TimeInterval(minutes) * 60)

            event.startDate = start
            event.endDate = end

            var notes = ""
            if !game.opponentName.isEmpty { notes += "Соперник: \(game.opponentName)\n" }
            notes += "Формат: \(game.format.title)\n"
            notes += "Покрытие: \(game.surface.title)\(game.isIndoor ? " (зал)" : " (улица)")\n"
            if !game.notes.isEmpty { notes += "\nЗаметки:\n\(game.notes)" }
            event.notes = notes

            event.calendar = eventStore.defaultCalendarForNewEvents

            do {
                try eventStore.save(event, span: .thisEvent)

                DispatchQueue.main.async {
                    calendarAlertTitle = "Добавлено в календарь"
                    let when = game.date.formatted(date: .abbreviated, time: .shortened)
                    calendarAlertMessage = "Событие создано на \(when)."
                    showCalendarAlert = true
                }
            } catch {
                DispatchQueue.main.async {
                    calendarAlertTitle = "Не удалось добавить"
                    calendarAlertMessage = "Ошибка: \(error.localizedDescription)"
                    showCalendarAlert = true
                }
            }
        }
    }
}
// MARK: - Editor
private struct GameEditorView: View {
    enum Mode { case create, edit }

    let mode: Mode
    let onSave: (TennisGame) -> Void

    @Environment(\.dismiss) private var dismiss
    @FocusState private var focused: Bool

    @State private var game: TennisGame

    init(initial: TennisGame, mode: Mode, onSave: @escaping (TennisGame) -> Void) {
        self._game = State(initialValue: initial)
        self.mode = mode
        self.onSave = onSave
    }

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
                        statusPickerCard

                        infoCard

                        if game.status == .planned {
                            plannedCard
                        } else {
                            playedCard
                        }

                        notesCard
                    }
                    .padding()
                }
            }
            .navigationTitle(mode == .create ? "Новая игра" : "Редактирование")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Отмена") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Сохранить") {
                        onSave(game)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { focused = false }
        }
    }

    private var statusPickerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Тип")
                .font(.headline)

            Picker("Тип", selection: $game.status) {
                Text("Планируемая").tag(TennisGame.Status.planned)
                Text("Сыгранная").tag(TennisGame.Status.played)
            }
            .pickerStyle(.segmented)

            Text(game.status == .planned
                 ? "Эта игра появится во вкладке “Планируемые”."
                 : "Эта игра появится во вкладке “Сыгранные”.")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Основное", systemImage: "info.circle")
                .font(.headline)

            TextField("Название (например: Игра с Антоном)", text: $game.title)
                .focused($focused)
                .padding()
                .background(Color.primary.opacity(0.05))
                .cornerRadius(12)

            HStack(spacing: 10) {
                TextField("Корт", text: $game.courtName)
                    .focused($focused)
                    .padding()
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(12)

                TextField("Город", text: $game.city)
                    .focused($focused)
                    .padding()
                    .background(Color.primary.opacity(0.05))
                    .cornerRadius(12)
            }

            DatePicker("Дата и время", selection: $game.date)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var plannedCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("План", systemImage: "calendar")
                .font(.headline)

            TextField("Соперник", text: $game.opponentName)
                .focused($focused)
                .padding()
                .background(Color.primary.opacity(0.05))
                .cornerRadius(12)

            Picker("Формат", selection: $game.format) {
                ForEach(TennisGame.MatchFormat.allCases, id: \.self) { Text($0.title).tag($0) }
            }
            .pickerStyle(.menu)

            Picker("Покрытие", selection: $game.surface) {
                ForEach(TennisGame.Surface.allCases, id: \.self) { Text($0.title).tag($0) }
            }
            .pickerStyle(.menu)

            Toggle("Зал", isOn: $game.isIndoor)

            Stepper("Ожидаемая длительность: \(max(30, game.durationMinutes)) мин", value: $game.durationMinutes, in: 30...240, step: 15)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var playedCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Результат", systemImage: "checkmark.seal")
                .font(.headline)

            HStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Твой счёт")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Stepper("\(game.myScore)", value: $game.myScore, in: 0...30)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Соперник")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Stepper("\(game.opponentScore)", value: $game.opponentScore, in: 0...30)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Picker("Итог", selection: $game.result) {
                ForEach(TennisGame.Result.allCases, id: \.self) { Text($0.title).tag($0) }
            }
            .pickerStyle(.segmented)

            Stepper("Длительность: \(max(10, game.durationMinutes)) мин", value: $game.durationMinutes, in: 10...300, step: 5)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Заметки", systemImage: "square.and.pencil")
                .font(.headline)

            TextField("Что важно запомнить (подача, тактика, самочувствие)...", text: $game.notes, axis: .vertical)
                .focused($focused)
                .lineLimit(3...8)
                .padding()
                .background(Color.primary.opacity(0.05))
                .cornerRadius(12)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

#Preview {
    GamesView()
}
