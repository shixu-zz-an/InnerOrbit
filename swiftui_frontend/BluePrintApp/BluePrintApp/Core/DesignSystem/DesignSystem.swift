import SwiftUI

enum AppColor {
    static let background = Color(uiColor: .systemGroupedBackground)
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    static let elevated = Color(uiColor: .systemBackground)
    static let primary = Color(red: 0.16, green: 0.35, blue: 0.64)
    static let primarySoft = Color(red: 0.88, green: 0.93, blue: 0.99)
    static let secondary = Color(red: 0.10, green: 0.45, blue: 0.43)
    static let secondarySoft = Color(red: 0.88, green: 0.96, blue: 0.94)
    static let warning = Color(red: 0.64, green: 0.42, blue: 0.12)
    static let warningSoft = Color(red: 0.98, green: 0.94, blue: 0.86)
    static let destructive = Color(red: 0.72, green: 0.18, blue: 0.16)
    static let ink = Color(uiColor: .label)
    static let inkMuted = Color(uiColor: .secondaryLabel)
    static let inkFaint = Color(uiColor: .tertiaryLabel)
    static let divider = Color(uiColor: .separator).opacity(0.38)
}

enum AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let sm: CGFloat = 12
    static let md: CGFloat = 16
    static let lg: CGFloat = 20
    static let xl: CGFloat = 24
    static let xxl: CGFloat = 32
    static let page: CGFloat = 20
}

enum AppRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
}

enum AppShadow {
    static let cardColor = Color.black.opacity(0.05)
    static let cardRadius: CGFloat = 14
}

enum AppTypography {
    static let title = Font.system(.largeTitle, design: .default, weight: .semibold)
    static let title2 = Font.system(.title2, design: .default, weight: .semibold)
    static let title3 = Font.system(.title3, design: .default, weight: .semibold)
    static let headline = Font.system(.headline, design: .default, weight: .semibold)
    static let body = Font.system(.body, design: .default, weight: .regular)
    static let bodyEmphasized = Font.system(.body, design: .default, weight: .semibold)
    static let callout = Font.system(.callout, design: .default, weight: .regular)
    static let subhead = Font.system(.subheadline, design: .default, weight: .regular)
    static let caption = Font.system(.caption, design: .default, weight: .semibold)
}

enum AppTone {
    case primary
    case secondary
    case warning
    case neutral
    case destructive

    var accent: Color {
        switch self {
        case .primary: AppColor.primary
        case .secondary: AppColor.secondary
        case .warning: AppColor.warning
        case .neutral: AppColor.inkMuted
        case .destructive: AppColor.destructive
        }
    }

    var soft: Color {
        switch self {
        case .primary: AppColor.primarySoft
        case .secondary: AppColor.secondarySoft
        case .warning: AppColor.warningSoft
        case .neutral: AppColor.surface
        case .destructive: Color.red.opacity(0.08)
        }
    }
}

