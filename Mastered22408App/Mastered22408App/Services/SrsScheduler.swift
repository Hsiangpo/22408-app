import Foundation

enum ReviewResult {
    case correct
    case wrong
}

struct SrsState {
    var ease: Double
    var interval: Int
    var dueDate: Date
    var lapses: Int
}

final class SrsScheduler {
    private let calendar = Calendar(identifier: .gregorian)

    func nextState(from current: SrsState, result: ReviewResult, reviewDate: Date = Date()) -> SrsState {
        var ease = current.ease
        var interval = current.interval
        var lapses = current.lapses

        switch result {
        case .correct:
            interval = max(1, Int((Double(interval)) * (1 + 0.15 * ease)))
            ease = min(3.0, ease + 0.05)
        case .wrong:
            interval = 1
            ease = max(1.3, ease - 0.2)
            lapses += 1
        }

        let dueDate = calendar.date(byAdding: .day, value: interval, to: reviewDate) ?? reviewDate
        return SrsState(ease: ease, interval: interval, dueDate: dueDate, lapses: lapses)
    }

    func scoring(for problem: Problem, reference: Date = Date()) -> Double {
        let overdueDays = max(0, reference.timeIntervalSince(problem.srsDueDate) / 86400)
        let streakFactor = Double(problem.streak) / max(1.0, Double(problem.reviewLogs.count))
        let difficulty = Double(problem.difficulty) / 5.0
        let stale = reference.timeIntervalSince(problem.updatedAt) / 86400
        return overdueDays * 1.0 + (1 - streakFactor) * 0.6 + stale * 0.4 + difficulty * 0.2
    }
}
