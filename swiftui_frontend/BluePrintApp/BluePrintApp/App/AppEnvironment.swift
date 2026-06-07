import SwiftUI

@MainActor
final class AppEnvironment: ObservableObject {
    @AppStorage("blueprint.hasCompletedOnboarding") var hasCompletedOnboarding = false
    @Published var birthProfile: BirthProfile
    @Published var today: TodayInsight
    @Published var blueprint: BlueprintReport
    @Published var messages: [GuideMessage]
    @Published var reflections: [ReflectionEntry]
    @Published var isAsking = false
    @Published var toast: ToastMessage?

    init(
        birthProfile: BirthProfile,
        today: TodayInsight,
        blueprint: BlueprintReport,
        messages: [GuideMessage],
        reflections: [ReflectionEntry]
    ) {
        self.birthProfile = birthProfile
        self.today = today
        self.blueprint = blueprint
        self.messages = messages
        self.reflections = reflections
    }

    static func preview() -> AppEnvironment {
        AppEnvironment(
            birthProfile: MockData.birthProfile,
            today: MockData.today,
            blueprint: MockData.blueprint,
            messages: [],
            reflections: MockData.reflections
        )
    }

    func completeOnboarding(with profile: BirthProfile) {
        birthProfile = profile
        hasCompletedOnboarding = true
        showToast(title: "Blueprint ready", message: "Your first private blueprint is ready to explore.")
    }

    func resetDemo() {
        hasCompletedOnboarding = false
        messages = []
        reflections = MockData.reflections
    }

    func saveReflection(prompt: String, content: String, source: String) {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        reflections.insert(
            ReflectionEntry(
                prompt: prompt,
                content: trimmed,
                source: source,
                createdAt: Date()
            ),
            at: 0
        )
        showToast(title: "Saved", message: "This reflection was added to Mine.")
    }

    func askGuide(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, !isAsking else { return }
        messages.append(.user(trimmed))
        isAsking = true
        Task {
            try? await Task.sleep(for: .milliseconds(650))
            let answer = GuideAnswer(
                headline: "Start by narrowing the choice",
                summary: "The question points less to a final answer and more to the condition you need before choosing. Make the next step smaller and observable.",
                sections: [
                    GuideAnswerSection(title: "Pattern", body: "When the stakes feel personal, you may try to solve the whole future before taking the next clean action."),
                    GuideAnswerSection(title: "Reframe", body: "Choose the move that gives you better information without forcing a permanent identity decision.")
                ],
                practicalStep: "Write the smallest test you can finish in the next 24 hours.",
                reflectionQuestion: "What would become clearer if this only had to be a next step, not a final verdict?"
            )
            messages.append(.assistant(answer))
            isAsking = false
        }
    }

    private func showToast(title: String, message: String) {
        toast = ToastMessage(title: title, message: message)
        Task {
            try? await Task.sleep(for: .seconds(2))
            if toast?.title == title {
                toast = nil
            }
        }
    }
}

