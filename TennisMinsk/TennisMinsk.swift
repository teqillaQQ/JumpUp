import SwiftUI
import SwiftData

@main
struct TennisMinskApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CourtSwiftData.self,
            PlayerProfileSwiftData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("onboarding.completed") private var onboardingCompleted: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainContentView()
                
                if !onboardingCompleted {
                    OnboardingView(isPresented: $onboardingCompleted)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
