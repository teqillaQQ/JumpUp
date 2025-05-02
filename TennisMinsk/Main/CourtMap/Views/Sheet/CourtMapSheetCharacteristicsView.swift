import SwiftUI

struct CourtMapSheetCharacteristicsView: View {
    let type: Court.CourtType
    let surface: [Court.SurfaceType]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Характеристики")
                .font(.headline)

            HStack {
                Image(systemName: "square.stack.3d.up.fill")
                Text("Тип корта: \(courtTypeText(type))")
            }

            HStack(alignment: .top) {
                Image(systemName: "circle.grid.2x2.fill")
                Text("Покрытие: ") +
                Text(surface.map { surfaceText($0) }.joined(separator: ", "))
            }
        }
        
        Divider()
    }

    private func courtTypeText(_ type: Court.CourtType) -> String {
        switch type {
        case .indoor: return "Крытый"
        case .outdoor: return "Открытый"
        case .mixed: return "Крытый и открытый"
        case .unknown: return "Неизвестно"
        }
    }

    private func surfaceText(_ surface: Court.SurfaceType) -> String {
        switch surface {
        case .hard: return "Хард"
        case .clay: return "Грунт"
        case .grass: return "Трава"
        case .carpet: return "Ковёр"
        case .artificialTurf: return "Искусственная трава"
        case .unknown: return "Неизвестно"
        }
    }
}

#Preview {
    CourtMapSheetCharacteristicsView(type: .indoor, surface: [.carpet, .hard])
}
