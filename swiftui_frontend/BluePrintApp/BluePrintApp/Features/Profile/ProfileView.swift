import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var showPrivacy = false
    @State private var showPremium = false

    var body: some View {
        NavigationStack {
            AppPage(title: "Mine", subtitle: "Account, blueprint, privacy, and saved reflections.") {
                AppCard(tone: .primary, padding: AppSpacing.xl) {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        HStack(spacing: AppSpacing.md) {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 44))
                                .foregroundStyle(AppColor.primary)
                            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                                Text(environment.birthProfile.name).font(AppTypography.title3)
                                Text("Current blueprint: \(environment.blueprint.archetype)")
                                    .font(AppTypography.subhead)
                                    .foregroundStyle(AppColor.inkMuted)
                            }
                        }
                        Text("\(environment.birthProfile.birthPlace) · \(environment.birthProfile.dateText)")
                            .font(AppTypography.callout)
                            .foregroundStyle(AppColor.inkMuted)
                    }
                }

                AppSectionHeader(title: "Blueprint")
                AppCard {
                    VStack(spacing: 0) {
                        AppListRow(icon: "square.grid.2x2", title: "Current blueprint", subtitle: environment.blueprint.archetype, tone: .primary)
                        Divider().padding(.leading, 46)
                        AppListRow(icon: "calendar", title: "Birth details", subtitle: "\(environment.birthProfile.timeText) · \(environment.birthProfile.timezone)", tone: .secondary)
                    }
                }

                AppSectionHeader(title: "Plan")
                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        AppListRow(icon: "checkmark.seal", title: "Free plan", subtitle: "Preview blueprint, Today, limited guide questions", tone: .neutral, accessory: "")
                        AppButton(title: "Learn about Premium", systemImage: "sparkles", style: .secondary) {
                            showPremium = true
                        }
                    }
                }

                AppSectionHeader(title: "Saved")
                AppCard {
                    if environment.reflections.isEmpty {
                        Text("No saved reflections yet.")
                            .font(AppTypography.callout)
                            .foregroundStyle(AppColor.inkMuted)
                    } else {
                        VStack(spacing: 0) {
                            ForEach(Array(environment.reflections.prefix(3).enumerated()), id: \.element.id) { index, item in
                                VStack(alignment: .leading, spacing: AppSpacing.xs) {
                                    Text(item.prompt).font(AppTypography.headline)
                                    Text(item.content).font(AppTypography.subhead).foregroundStyle(AppColor.inkMuted).lineLimit(3)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, AppSpacing.sm)
                                if index < min(environment.reflections.count, 3) - 1 {
                                    Divider()
                                }
                            }
                        }
                    }
                }

                AppSectionHeader(title: "Settings")
                AppCard {
                    VStack(spacing: 0) {
                        Button { showPrivacy = true } label: {
                            AppListRow(icon: "lock.shield", title: "Privacy", subtitle: "Data use and AI boundaries", tone: .neutral)
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 46)
                        AppListRow(icon: "doc.text", title: "Terms and disclaimer", subtitle: "Self-reflection only", tone: .neutral)
                    }
                }
            }
            .navigationTitle("Mine")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showPrivacy) {
                infoSheet(title: "Privacy", body: "BluePrint uses birth details, conversations, and saved reflections to personalize your experience. Your data should remain transparent and manageable, with clear options to export or delete it before release. Guidance is for self-reflection only and does not provide medical, legal, financial, or emergency advice.")
            }
            .sheet(isPresented: $showPremium) {
                infoSheet(title: "Premium", body: "Premium is reserved for full blueprint access, more AI follow-up, and relationship reports. Purchasing is not available in this build yet, so this screen is informational only.")
            }
        }
    }

    private func infoSheet(title: String, body: String) -> some View {
        NavigationStack {
            AppPage(title: title) {
                Text(body)
                    .font(AppTypography.body)
                    .lineSpacing(5)
                    .foregroundStyle(AppColor.ink)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showPrivacy = false
                        showPremium = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}
