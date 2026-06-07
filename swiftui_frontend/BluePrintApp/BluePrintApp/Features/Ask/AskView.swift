import SwiftUI

struct AskView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var input = ""

    private let suggestions = [
        "Why do I keep getting stuck lately?",
        "Which choice is worth testing first?",
        "What pattern repeats in relationships?",
        "What should I focus on this month?"
    ]

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AppPage(title: "Ask", subtitle: "Start with one real question. Answers stay reflective and practical.") {
                    AppSectionHeader(title: "Suggested questions")
                    FlowLayout(items: suggestions) { item in
                        AppTag(title: item, systemImage: "bubble.left", selected: false) {
                            environment.askGuide(item)
                        }
                    }

                    if environment.messages.isEmpty && !environment.isAsking {
                        AppEmptyState(
                            icon: "lock.shield",
                            title: "Private by default",
                            message: "Your question can use blueprint clues, but it will not make a decision for you."
                        )
                    }

                    VStack(spacing: AppSpacing.md) {
                        ForEach(environment.messages) { message in
                            switch message {
                            case .user(let text):
                                userBubble(text)
                            case .assistant(let answer):
                                answerCard(answer)
                            }
                        }
                        if environment.isAsking {
                            AppCard {
                                HStack(spacing: AppSpacing.sm) {
                                    ProgressView()
                                    Text("Thinking through the pattern...")
                                        .font(AppTypography.callout)
                                        .foregroundStyle(AppColor.inkMuted)
                                }
                            }
                        }
                    }
                    .padding(.bottom, 86)
                }

                AppBottomInputBar(text: $input, isSending: environment.isAsking) {
                    let text = input
                    input = ""
                    environment.askGuide(text)
                }
            }
            .navigationTitle("Ask")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func userBubble(_ text: String) -> some View {
        HStack {
            Spacer(minLength: 44)
            Text(text)
                .font(AppTypography.body)
                .foregroundStyle(.white)
                .padding(AppSpacing.md)
                .background(AppColor.primary)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        }
    }

    private func answerCard(_ answer: GuideAnswer) -> some View {
        AppCard(tone: .primary) {
            VStack(alignment: .leading, spacing: AppSpacing.md) {
                AppTag(title: "Guide", systemImage: "sparkles", selected: true)
                Text(answer.headline).font(AppTypography.title3)
                Text(answer.summary).font(AppTypography.callout).foregroundStyle(AppColor.inkMuted)
                ForEach(answer.sections, id: \.title) { section in
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        Text(section.title).font(AppTypography.headline)
                        Text(section.body).font(AppTypography.callout).foregroundStyle(AppColor.inkMuted)
                    }
                }
                Text("Try this: \(answer.practicalStep)")
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.secondary)
                    .padding(AppSpacing.md)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(AppColor.secondarySoft)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
                AppButton(title: "Save answer", systemImage: "bookmark", style: .secondary) {
                    environment.saveReflection(prompt: answer.reflectionQuestion, content: answer.summary, source: "AI guide")
                }
            }
        }
    }
}

struct FlowLayout<Item: Hashable, Content: View>: View {
    let items: [Item]
    let content: (Item) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: AppSpacing.xs)], alignment: .leading, spacing: AppSpacing.xs) {
            ForEach(items, id: \.self) { item in
                content(item)
            }
        }
    }
}

