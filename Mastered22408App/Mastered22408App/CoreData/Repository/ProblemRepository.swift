import Foundation
import CoreData

enum ProblemRepositoryError: Error {
    case notFound
}

struct ProblemFilter {
    var subject: String?
    var chapter: String?
    var tags: [String] = []
    var difficultyRange: ClosedRange<Int> = 1...5
    var searchKeyword: String?
}

struct ProblemDTO {
    let id: UUID
    let subject: String
    let chapter: String?
    let sourceTitle: String?
    let sourceMeta: String?
    let questionText: String?
    let answerText: String?
    let imagePaths: [String]
    let answerImages: [String]
    let tags: [String]
    let latex: [String]
    let difficulty: Int
    let hasFormula: Bool
}

protocol ProblemRepository {
    func fetchDueProblems(on date: Date) throws -> [Problem]
    func fetchAll(filter: ProblemFilter) throws -> [Problem]
    func upsert(using dto: ProblemDTO, now: Date) throws
    func updateSRS(id: UUID, state: SrsState) throws
    func logReview(problemId: UUID, result: ReviewResult, duration: TimeInterval, note: String?)
}
