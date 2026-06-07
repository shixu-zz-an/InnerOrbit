import SwiftUI

struct TodayView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var reflection = ""

    var body: some View {
        NavigationStack {
            AppPage(title: "Today", subtitle: "One focus, one next step.") {
                AppCard(tone: .primary, padding: AppSpacing.xl) {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        AppTag(title: "Today's focus", systemImage: "sun.max", selected: true)
                        Text(environment.today.focusTitle)
                            .font(AppTypography.title2)
                            .foregroundStyle(AppColor.ink)
                            .fixedSize(horizontal: false, vertical: true)
                        Text(environment.today.focusBody)
                            .font(AppTypography.callout)
                            .foregroundStyle(AppColor.inkMuted)
                        AppButton(title: "Break down the next step", systemImage: "arrow.turn.down.right") {
                            environment.askGuide(environment.today.focusTitle)
                        }
                    }
                }

                AppCard {
                    VStack(spacing: 0) {
                        AppListRow(icon: "calendar", title: "Weekly theme", subtitle: environment.today.weeklyTheme, tone: .primary, accessory: nil)
                        Divider().padding(.leading, 46)
                        AppListRow(icon: "checkmark.circle", title: "Today action", subtitle: environment.today.action, tone: .secondary, accessory: nil)
                    }
                }

                AppSectionHeader(title: "Today signals")
                VStack(spacing: AppSpacing.md) {
                    signalCard(title: environment.today.challengeTitle, body: environment.today.challengeBody, icon: "exclamationmark.circle", tone: .warning)
                    signalCard(title: environment.today.opportunityTitle, body: environment.today.opportunityBody, icon: "leaf", tone: .secondary)
                }

                AppSectionHeader(title: "Reflection")
                AppTextEditor(placeholder: environment.today.reflectionQuestion, text: $reflection)
                AppButton(title: "Save reflection", systemImage: "bookmark", style: reflection.isEmpty ? .secondary : .primary) {
                    environment.saveReflection(prompt: environment.today.reflectionQuestion, content: reflection, source: "Daily insight")
                    reflection = ""
                }
                .disabled(reflection.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("Today")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func signalCard(title: String, body: String, icon: String, tone: AppTone) -> some View {
        AppCard(tone: tone) {
            HStack(alignment: .top, spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(tone.accent)
                    .frame(width: 34, height: 34)
                    .background(tone.soft)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                    Text(title).font(AppTypography.headline)
                    Text(body).font(AppTypography.callout).foregroundStyle(AppColor.inkMuted)
                }
            }
        }
    }
}

