import Foundation

enum MockData {
    static let birthProfile = BirthProfile(
        name: "You",
        birthDate: Calendar.current.date(from: DateComponents(year: 1994, month: 8, day: 21)) ?? Date(),
        birthTime: Calendar.current.date(from: DateComponents(year: 1994, month: 8, day: 21, hour: 14, minute: 30)),
        timePrecision: .exact,
        birthPlace: "Shanghai, China",
        timezone: "Asia/Shanghai",
        traditionalCycle: "Prefer not to say"
    )

    static let today = TodayInsight(
        focusTitle: "Let one honest signal be enough",
        focusBody: "Today works better when you choose one grounded move instead of trying to settle every possible outcome.",
        weeklyTheme: "Preparation is not waiting for perfect",
        action: "Complete one direct action before widening the plan.",
        challengeTitle: "Over-carrying the outcome",
        challengeBody: "You may be treating a next step as if it has to decide the whole future.",
        opportunityTitle: "A cleaner next step",
        opportunityBody: "Make the choice smaller, observable, and easier to finish.",
        reflectionQuestion: "Where are you turning uncertainty into a story?"
    )

    static let blueprint = BlueprintReport(
        archetype: "Steady Strategist",
        headline: "You create calm by turning uncertainty into structure.",
        summary: "Your blueprint suggests a practical, observant style: you notice what is unstable, then build a container that helps decisions become workable.",
        sections: [
            BlueprintSection(label: "Core pattern", title: "Structure before momentum", body: "You tend to move best after the shape of a situation is clear. This can make you reliable under pressure, but it can also delay action when the perfect map is not available.", tone: .primary),
            BlueprintSection(label: "Hidden strength", title: "Quiet calibration", body: "You often sense small mismatches before other people name them. Used well, this becomes judgment, timing, and a careful ability to simplify noise.", tone: .secondary),
            BlueprintSection(label: "Growth reminder", title: "Do not make clarity a gate", body: "Sometimes the next step has to create clarity rather than wait for it. A low-risk test can be more honest than another round of analysis.", tone: .warning),
            BlueprintSection(label: "Relationship clue", title: "Safety through consistency", body: "In close relationships, you may trust what is steady more than what is intense. Name this clearly so others do not mistake your pace for distance.", tone: .secondary),
            BlueprintSection(label: "Action suggestion", title: "Choose a 24-hour test", body: "When you feel stuck, define an action small enough to finish within a day and useful enough to change what you know.", tone: .primary)
        ]
    )

    static let reflections = [
        ReflectionEntry(
            prompt: "Where are you turning uncertainty into a story?",
            content: "I keep treating the career choice as permanent. The next useful move is probably one conversation, not a full identity decision.",
            source: "Daily insight",
            createdAt: Date().addingTimeInterval(-86400)
        )
    ]
}

