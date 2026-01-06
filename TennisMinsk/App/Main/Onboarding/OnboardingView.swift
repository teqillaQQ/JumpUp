//
//  OnboardingView.swift
//  TennisMinsk
//
//  Created by Uladzislau Simanau on 6.01.26.
//

import SwiftUI

struct OnboardingView: View {
    /// Передай сюда @AppStorage("onboarding.completed") из App:
    /// OnboardingView(isPresented: $onboardingCompleted)
    /// Внутри: true = онбординг завершён, значит скрываем.
    @Binding var isPresented: Bool

    @State private var step: Int = 0

    private let steps: [OnboardingStep] = [
        .init(
            title: "Корты Минска",
            subtitle: "Смотри список теннисных кортов и быстро находи подходящий по локации и условиям.",
            systemImage: "map"
        ),
        .init(
            title: "Детальная информация",
            subtitle: "Открывай карточку корта и читай подробности: описание, особенности и полезную информацию.",
            systemImage: "doc.text.magnifyingglass"
        ),
        .init(
            title: "Планируй игры и история",
            subtitle: "Планируй теннисные игры и отслеживай историю сыгранных матчей в одном месте.",
            systemImage: "calendar.badge.clock"
        )
    ]

    var body: some View {
        ZStack {
            // НЕ прозрачный фон: полностью перекрывает MainContentView
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 18)
                    .padding(.top, 14)

                Spacer(minLength: 18)

                // Карточка шага
                stepCard
                    .padding(.horizontal, 18)

                Spacer(minLength: 18)

                // Нижняя панель с прогрессом и кнопками
                bottomPanel
                    .padding(.horizontal, 18)
                    .padding(.bottom, 18)
            }
        }
        .interactiveDismissDisabled(true) // если покажешь как .sheet
        .statusBarHidden(false)
    }
}

// MARK: - UI parts
private extension OnboardingView {

    var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.08, blue: 0.12),
                    Color(red: 0.04, green: 0.05, blue: 0.09)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // “Спорт” атмосфера: мягкие световые пятна
            Circle()
                .fill(Color.accentColor.opacity(0.20))
                .frame(width: 320, height: 320)
                .blur(radius: 40)
                .offset(x: -120, y: -220)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 420, height: 420)
                .blur(radius: 55)
                .offset(x: 170, y: -120)

            Circle()
                .fill(Color.green.opacity(0.10))
                .frame(width: 360, height: 360)
                .blur(radius: 60)
                .offset(x: 130, y: 260)

            // Едва заметная “сетка корта”
            CourtGridPattern()
                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                .blendMode(.overlay)
                .padding(24)
        }
    }

    var topBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Tennis Minsk")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("Быстрый старт")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            Button {
                finish()
            } label: {
                Text("Пропустить")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(.white.opacity(0.08))
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }

    var stepCard: some View {
        let s = steps[step]

        return VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.white.opacity(0.10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(.white.opacity(0.10), lineWidth: 1)
                        )

                    Image(systemName: s.systemImage)
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 6) {
                    Text(s.title)
                        .font(.title3.bold())
                        .foregroundStyle(.white)

                    Text(s.subtitle)
                        .font(.body)
                        .foregroundStyle(.white.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 0)
            }

            // “фишка” снизу: мини-подсказки (как теги)
            HStack(spacing: 8) {
                ForEach(s.chips, id: \.self) { chip in
                    Text(chip)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(.white.opacity(0.08))
                        .clipShape(Capsule())
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
        )
    }

    var bottomPanel: some View {
        VStack(spacing: 14) {
            progressBar

            HStack(spacing: 12) {
                Button {
                    back()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "chevron.left")
                        Text("Назад")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(step == 0 ? .white.opacity(0.35) : .white.opacity(0.90))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.white.opacity(step == 0 ? 0.05 : 0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
                .disabled(step == 0)

                Button {
                    nextOrFinish()
                } label: {
                    HStack(spacing: 10) {
                        Text(step < steps.count - 1 ? "Далее" : "Начать")
                        Image(systemName: step < steps.count - 1 ? "chevron.right" : "checkmark")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.black.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [Color.white.opacity(0.95), Color.white.opacity(0.78)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(.white.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
        )
    }

    var progressBar: some View {
        let total = CGFloat(steps.count)
        let current = CGFloat(step + 1)
        let progress = total == 0 ? 0 : (current / total)

        return VStack(spacing: 8) {
            HStack {
                Text("Шаг \(step + 1) из \(steps.count)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.75))
                Spacer()
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.10))
                        .frame(height: 10)

                    Capsule()
                        .fill(Color.accentColor.opacity(0.85))
                        .frame(width: max(10, geo.size.width * progress), height: 10)
                        .animation(.easeInOut(duration: 0.25), value: step)
                }
            }
            .frame(height: 10)
        }
    }
}

// MARK: - Actions
private extension OnboardingView {
    func back() {
        guard step > 0 else { return }
        step -= 1
    }

    func nextOrFinish() {
        if step < steps.count - 1 {
            step += 1
        } else {
            finish()
        }
    }

    func finish() {
        isPresented = true
    }
}

// MARK: - Models
private struct OnboardingStep {
    let title: String
    let subtitle: String
    let systemImage: String

    var chips: [String] {
        switch title {
        case "Корты Минска":
            return ["Список", "Локации", "Удобный поиск"]
        case "Детальная информация":
            return ["Описание", "Особенности", "Полезно"]
        default:
            return ["Планирование", "История", "Прогресс"]
        }
    }
}

// MARK: - Decorative “court grid”
private struct CourtGridPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()

        // outer border
        p.addRoundedRect(in: rect, cornerSize: CGSize(width: 22, height: 22))

        // vertical lines
        let v1 = rect.minX + rect.width * 0.33
        let v2 = rect.minX + rect.width * 0.66
        p.move(to: CGPoint(x: v1, y: rect.minY))
        p.addLine(to: CGPoint(x: v1, y: rect.maxY))
        p.move(to: CGPoint(x: v2, y: rect.minY))
        p.addLine(to: CGPoint(x: v2, y: rect.maxY))

        // horizontal lines
        let h1 = rect.minY + rect.height * 0.33
        let h2 = rect.minY + rect.height * 0.66
        p.move(to: CGPoint(x: rect.minX, y: h1))
        p.addLine(to: CGPoint(x: rect.maxX, y: h1))
        p.move(to: CGPoint(x: rect.minX, y: h2))
        p.addLine(to: CGPoint(x: rect.maxX, y: h2))

        // center line
        let midY = rect.midY
        p.move(to: CGPoint(x: rect.minX, y: midY))
        p.addLine(to: CGPoint(x: rect.maxX, y: midY))

        return p
    }
}

#Preview {
    OnboardingView(isPresented: .constant(false))
        .tint(.green)
}
