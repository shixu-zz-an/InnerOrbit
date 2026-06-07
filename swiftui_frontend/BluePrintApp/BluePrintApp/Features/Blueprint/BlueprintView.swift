import SwiftUI

struct BlueprintView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        NavigationStack {
            AppPage(title: "Blueprint", subtitle: "A quiet overview of your core pattern, not a verdict.") {
                AppCard(tone: .primary, padding: AppSpacing.xl) {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        Text(environment.blueprint.archetype)
                            .font(AppTypography.title2)
                        Text(environment.blueprint.headline)
                            .font(AppTypography.callout)
                            .foregroundStyle(AppColor.inkMuted)
                        Text(environment.blueprint.summary)
                            .font(AppTypography.body)
                            .foregroundStyle(AppColor.ink)
                        AppButton(title: "Ask about this blueprint", systemImage: "bubble.left.and.bubble.right", style: .secondary) {
                            environment.askGuide(environment.blueprint.headline)
                        }
                    }
                }

                AppSectionHeader(title: "Sections")
                AppCard {
                    VStack(spacing: 0) {
                        ForEach(Array(environment.blueprint.sections.enumerated()), id: \.element.id) { index, section in
                            NavigationLink(value: section) {
                                AppListRow(
                                    icon: icon(for: section.label),
                                    title: section.title,
                                    subtitle: section.label,
                                    tone: section.tone,
                                    accessory: section.locked ? "Locked" : nil
                                )
                            }
                            .buttonStyle(.plain)
                            if index < environment.blueprint.sections.count - 1 {
                                Divider().padding(.leading, 46)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Blueprint")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: BlueprintSection.self) { section in
                BlueprintSectionDetail(section: section)
            }
        }
    }

    private func icon(for label: String) -> String {
        if label.contains("strength") { return "sparkles" }
        if label.contains("Growth") { return "arrow.up.right" }
        if label.contains("Relationship") { return "heart" }
        if label.contains("Action") { return "checkmark.circle" }
        return "square.grid.2x2"
    }
}

struct BlueprintSectionDetail: View {
    @EnvironmentObject private var environment: AppEnvironment
    let section: BlueprintSection
    @State private var note = ""

    var body: some View {
        AppPage(title: section.title, subtitle: section.label) {
            Text(section.body)
                .font(AppTypography.body)
                .lineSpacing(5)
                .foregroundStyle(AppColor.ink)
                .fixedSize(horizontal: false, vertical: true)

            AppButton(title: "Ask around this point", systemImage: "bubble.left") {
                environment.askGuide("\(section.title). \(section.body)")
            }

            AppSectionHeader(title: "Save a reflection")
            AppTextEditor(placeholder: "What feels useful or questionable here?", text: $note)
            AppButton(title: "Save to reflections", systemImage: "bookmark", style: note.isEmpty ? .secondary : .primary) {
                environment.saveReflection(prompt: section.title, content: note, source: "Blueprint")
                note = ""
            }
            .disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .navigationTitle(section.label)
        .navigationBarTitleDisplayMode(.inline)
    }
}

