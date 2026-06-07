import Foundation

struct BirthProfile: Identifiable, Hashable {
    var id = UUID().uuidString
    var name: String
    var birthDate: Date
    var birthTime: Date?
    var timePrecision: TimePrecision
    var birthPlace: String
    var timezone: String
    var traditionalCycle: String

    var dateText: String {
        birthDate.formatted(date: .abbreviated, time: .omitted)
    }

    var timeText: String {
        switch timePrecision {
        case .unknown:
            "Unknown"
        case .approximate:
            "Around \(birthTime?.formatted(date: .omitted, time: .shortened) ?? "12:00")"
        case .exact:
            birthTime?.formatted(date: .omitted, time: .shortened) ?? "Not set"
        }
    }
}

enum TimePrecision: String, CaseIterable, Identifiable {
    case exact = "Exact"
    case approximate = "Approx"
    case unknown = "Unknown"

    var id: String { rawValue }
}

struct TodayInsight {
    var focusTitle: String
    var focusBody: String
    var weeklyTheme: String
    var action: String
    var challengeTitle: String
    var challengeBody: String
    var opportunityTitle: String
    var opportunityBody: String
    var reflectionQuestion: String
}

struct BlueprintReport {
    var archetype: String
    var headline: String
    var summary: String
    var sections: [BlueprintSection]
}

struct BlueprintSection: Identifiable, Hashable {
    let id = UUID()
    var label: String
    var title: String
    var body: String
    var tone: AppTone
    var locked: Bool = false
}

struct GuideAnswer: Hashable {
    var headline: String
    var summary: String
    var sections: [GuideAnswerSection]
    var practicalStep: String
    var reflectionQuestion: String
}

struct GuideAnswerSection: Hashable {
    var title: String
    var body: String
}

enum GuideMessage: Identifiable, Hashable {
    case user(String)
    case assistant(GuideAnswer)

    var id: String {
        switch self {
        case .user(let text): "user-\(text.hashValue)"
        case .assistant(let answer): "assistant-\(answer.hashValue)"
        }
    }
}

struct ReflectionEntry: Identifiable, Hashable {
    let id = UUID()
    var prompt: String
    var content: String
    var source: String
    var createdAt: Date
}

