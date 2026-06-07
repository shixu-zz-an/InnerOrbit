import SwiftUI

struct AppPage<Content: View>: View {
    let title: String?
    let subtitle: String?
    let content: Content

    init(title: String? = nil, subtitle: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                if title != nil || subtitle != nil {
                    VStack(alignment: .leading, spacing: AppSpacing.xs) {
                        if let title {
                            Text(title).font(AppTypography.title2).foregroundStyle(AppColor.ink)
                        }
                        if let subtitle {
                            Text(subtitle).font(AppTypography.callout).foregroundStyle(AppColor.inkMuted)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, AppSpacing.md)
                }
                content
            }
            .padding(.horizontal, AppSpacing.page)
            .padding(.bottom, 96)
        }
        .background(AppColor.background.ignoresSafeArea())
    }
}

struct AppCard<Content: View>: View {
    var tone: AppTone = .neutral
    var padding: CGFloat = AppSpacing.lg
    let content: Content

    init(tone: AppTone = .neutral, padding: CGFloat = AppSpacing.lg, @ViewBuilder content: () -> Content) {
        self.tone = tone
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(tone == .neutral ? AppColor.elevated : tone.soft)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                    .stroke(AppColor.divider, lineWidth: 0.5)
            )
            .shadow(color: AppShadow.cardColor, radius: AppShadow.cardRadius, y: 4)
    }
}

struct AppButton: View {
    enum Style {
        case primary
        case secondary
        case quiet
    }

    let title: String
    var systemImage: String?
    var style: Style = .primary
    var isLoading = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView().controlSize(.small)
                } else if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(AppTypography.bodyEmphasized)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .padding(.horizontal, AppSpacing.md)
            .foregroundStyle(foreground)
            .background(background)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .opacity(isLoading ? 0.72 : 1)
    }

    private var background: Color {
        switch style {
        case .primary: AppColor.primary
        case .secondary: AppColor.primarySoft
        case .quiet: .clear
        }
    }

    private var foreground: Color {
        switch style {
        case .primary: .white
        case .secondary, .quiet: AppColor.primary
        }
    }
}

struct AppSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(AppTypography.caption)
            .foregroundStyle(AppColor.inkMuted)
            .textCase(.uppercase)
            .tracking(0)
            .padding(.top, AppSpacing.sm)
    }
}

struct AppListRow: View {
    let icon: String
    let title: String
    var subtitle: String?
    var tone: AppTone = .neutral
    var accessory: String?

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(tone.accent)
                .frame(width: 34, height: 34)
                .background(tone.soft)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md, style: .continuous))
            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(title).font(AppTypography.headline).foregroundStyle(AppColor.ink)
                if let subtitle {
                    Text(subtitle).font(AppTypography.subhead).foregroundStyle(AppColor.inkMuted)
                }
            }
            Spacer(minLength: AppSpacing.sm)
            if let accessory {
                Text(accessory).font(AppTypography.subhead).foregroundStyle(AppColor.inkMuted)
            } else {
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColor.inkFaint)
            }
        }
        .padding(.vertical, AppSpacing.sm)
    }
}

struct AppTag: View {
    let title: String
    var systemImage: String?
    var selected = false
    var action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title).lineLimit(2)
            }
            .font(AppTypography.subhead)
            .foregroundStyle(selected ? .white : AppColor.primary)
            .padding(.horizontal, AppSpacing.sm)
            .padding(.vertical, AppSpacing.xs)
            .background(selected ? AppColor.primary : AppColor.primarySoft)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

struct AppTextEditor: View {
    let placeholder: String
    @Binding var text: String
    var minHeight: CGFloat = 110

    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(AppTypography.body)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight)
                .padding(AppSpacing.sm)
            if text.isEmpty {
                Text(placeholder)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.inkFaint)
                    .padding(AppSpacing.lg)
                    .allowsHitTesting(false)
            }
        }
        .background(AppColor.elevated)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous)
                .stroke(AppColor.divider, lineWidth: 0.5)
        )
    }
}

struct AppBottomInputBar: View {
    @Binding var text: String
    var isSending: Bool
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            TextField("Say what you are working through", text: $text, axis: .vertical)
                .lineLimit(1...4)
                .font(AppTypography.body)
                .padding(.horizontal, AppSpacing.md)
                .padding(.vertical, AppSpacing.sm)
                .background(AppColor.surface)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg, style: .continuous))
            Button(action: onSend) {
                Image(systemName: isSending ? "hourglass" : "arrow.up")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 38, height: 38)
                    .background(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColor.inkFaint : AppColor.primary)
                    .clipShape(Circle())
            }
            .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSending)
        }
        .padding(.horizontal, AppSpacing.md)
        .padding(.vertical, AppSpacing.sm)
        .background(.regularMaterial)
    }
}

struct AppEmptyState: View {
    let icon: String
    let title: String
    let message: String

    var body: some View {
        AppCard {
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                Text(title).font(AppTypography.title3)
                Text(message).font(AppTypography.callout).foregroundStyle(AppColor.inkMuted)
            }
        }
    }
}

struct ToastOverlay: View {
    let toast: ToastMessage

    var body: some View {
        VStack {
            Spacer()
            AppCard(tone: .primary, padding: AppSpacing.md) {
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(toast.title).font(AppTypography.headline)
                    Text(toast.message).font(AppTypography.subhead).foregroundStyle(AppColor.inkMuted)
                }
            }
            .padding(.horizontal, AppSpacing.page)
            .padding(.bottom, AppSpacing.md)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

