import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var page = 0
    @State private var birthDate = MockData.birthProfile.birthDate
    @State private var birthTime = MockData.birthProfile.birthTime ?? Date()
    @State private var precision: TimePrecision = .exact
    @State private var place = MockData.birthProfile.birthPlace
    @State private var timezone = MockData.birthProfile.timezone
    @State private var cycle = "Prefer not to say"
    @State private var showDate = false
    @State private var showTime = false
    @State private var showPlace = false
    @State private var isGenerating = false

    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea()
            if page < 3 {
                valueScreen
            } else {
                birthSetup
            }
        }
        .sheet(isPresented: $showDate) {
            pickerSheet(title: "Birth date") {
                DatePicker("Birth date", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                    .datePickerStyle(.graphical)
            }
        }
        .sheet(isPresented: $showTime) {
            pickerSheet(title: "Birth time") {
                DatePicker("Birth time", selection: $birthTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
        }
        .sheet(isPresented: $showPlace) {
            pickerSheet(title: "Birthplace") {
                VStack(spacing: AppSpacing.md) {
                    TextField("City, region, country", text: $place)
                        .textFieldStyle(.roundedBorder)
                    TextField("IANA timezone, e.g. Asia/Shanghai", text: $timezone)
                        .textFieldStyle(.roundedBorder)
                    Text("Location search is not connected yet, so this demo keeps the fields manual and does not submit fake coordinates.")
                        .font(AppTypography.footnoteCompat)
                        .foregroundStyle(AppColor.inkMuted)
                }
            }
        }
    }

    private var valueScreen: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xl) {
            Spacer(minLength: AppSpacing.xxl)
            Text("BluePrint")
                .font(AppTypography.title)
                .foregroundStyle(AppColor.ink)
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                Text(onboardingTitle)
                    .font(AppTypography.title2)
                Text(onboardingBody)
                    .font(AppTypography.callout)
                    .foregroundStyle(AppColor.inkMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            AppCard(tone: page == 1 ? .secondary : .primary) {
                HStack(alignment: .top, spacing: AppSpacing.md) {
                    Image(systemName: onboardingIcon)
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(page == 1 ? AppColor.secondary : AppColor.primary)
                    Text(onboardingCard)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.ink)
                }
            }
            Spacer()
            HStack(spacing: AppSpacing.sm) {
                ForEach(0..<3) { index in
                    Capsule()
                        .fill(index == page ? AppColor.primary : AppColor.divider)
                        .frame(width: index == page ? 28 : 8, height: 8)
                }
                Spacer()
                Button("Skip") { page = 3 }
                    .font(AppTypography.bodyEmphasized)
                    .foregroundStyle(AppColor.inkMuted)
            }
            AppButton(title: page == 2 ? "Set up my blueprint" : "Continue", systemImage: "arrow.right") {
                withAnimation(.snappy) { page += 1 }
            }
        }
        .padding(AppSpacing.page)
    }

    private var birthSetup: some View {
        NavigationStack {
            AppPage(
                title: "Set up your first blueprint",
                subtitle: "A few details help generate a personal map. You can keep the time approximate or unknown."
            ) {
                AppCard {
                    VStack(spacing: 0) {
                        setupRow(icon: "calendar", label: "Birth date", value: birthDate.formatted(date: .abbreviated, time: .omitted)) { showDate = true }
                        Divider().padding(.leading, 46)
                        setupRow(icon: "clock", label: "Birth time", value: timeValue) {
                            if precision != .unknown { showTime = true }
                        }
                        Divider().padding(.leading, 46)
                        setupRow(icon: "mappin.and.ellipse", label: "Birthplace", value: place) { showPlace = true }
                        Divider().padding(.leading, 46)
                        setupRow(icon: "globe", label: "Timezone", value: timezone) { showPlace = true }
                    }
                }

                AppSectionHeader(title: "Time accuracy")
                HStack(spacing: AppSpacing.xs) {
                    ForEach(TimePrecision.allCases) { item in
                        AppTag(title: item.rawValue, selected: precision == item) {
                            precision = item
                        }
                    }
                }

                AppSectionHeader(title: "Traditional calculation")
                AppCard {
                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                        Picker("Traditional cycle", selection: $cycle) {
                            Text("Prefer not to say").tag("Prefer not to say")
                            Text("Female").tag("Female")
                            Text("Male").tag("Male")
                        }
                        .pickerStyle(.segmented)
                        Text("This is only reserved for traditional timing math. It does not define your identity.")
                            .font(AppTypography.subhead)
                            .foregroundStyle(AppColor.inkMuted)
                    }
                }

                AppButton(title: "Generate my blueprint", systemImage: "sparkles", isLoading: isGenerating) {
                    generate()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Skip") {
                        environment.completeOnboarding(with: MockData.birthProfile)
                    }
                }
            }
        }
    }

    private func setupRow(icon: String, label: String, value: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .foregroundStyle(AppColor.primary)
                    .frame(width: 32, height: 32)
                    .background(AppColor.primarySoft)
                    .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                    Text(label).font(AppTypography.subhead).foregroundStyle(AppColor.inkMuted)
                    Text(value.isEmpty ? "Not set" : value)
                        .font(AppTypography.headline)
                        .foregroundStyle(AppColor.ink)
                        .lineLimit(2)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(AppColor.inkFaint)
            }
            .padding(.vertical, AppSpacing.sm)
        }
        .buttonStyle(.plain)
    }

    private func pickerSheet<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: AppSpacing.lg) {
                content()
                Spacer()
            }
            .padding(AppSpacing.page)
            .background(AppColor.background)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showDate = false
                        showTime = false
                        showPlace = false
                    }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }

    private var timeValue: String {
        switch precision {
        case .unknown: "Unknown"
        case .approximate: "Around \(birthTime.formatted(date: .omitted, time: .shortened))"
        case .exact: birthTime.formatted(date: .omitted, time: .shortened)
        }
    }

    private func generate() {
        guard !place.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        isGenerating = true
        Task {
            try? await Task.sleep(for: .milliseconds(900))
            let profile = BirthProfile(
                name: "You",
                birthDate: birthDate,
                birthTime: precision == .unknown ? nil : birthTime,
                timePrecision: precision,
                birthPlace: place,
                timezone: timezone,
                traditionalCycle: cycle
            )
            environment.completeOnboarding(with: profile)
        }
    }

    private var onboardingTitle: String {
        ["Notice the patterns that keep returning", "Use reflection, not fatalism", "Generate your first personal blueprint"][page]
    }

    private var onboardingBody: String {
        ["BluePrint helps organize recurring choices, relationship signals, and moments of uncertainty into a calmer structure.", "The app does not diagnose, predict fate, or make decisions for you. It helps you see the next useful step.", "Start with a few birth details, then use Today, Blueprint, and Ask as a private self-exploration loop."][page]
    }

    private var onboardingCard: String {
        ["One focus at a time. One next step you can actually take.", "Guidance stays reflective and practical, with clear boundaries around high-risk advice.", "Your first blueprint becomes a calm starting point for Today, Ask, and deeper reflection."][page]
    }

    private var onboardingIcon: String {
        ["eye", "lock.shield", "sparkles"][page]
    }
}

private extension AppTypography {
    static let footnoteCompat = Font.system(.footnote, design: .default, weight: .regular)
}
