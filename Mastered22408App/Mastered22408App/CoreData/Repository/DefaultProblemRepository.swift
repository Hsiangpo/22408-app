import Foundation
import CoreData

final class DefaultProblemRepository: ProblemRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchDueProblems(on date: Date) throws -> [Problem] {
        let request = Problem.fetchRequest()
        request.predicate = NSPredicate(format: "srsDueDate <= %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "srsDueDate", ascending: true)]
        return try context.fetch(request)
    }

    func fetchAll(filter: ProblemFilter) throws -> [Problem] {
        let request = Problem.fetchRequest()
        var predicates: [NSPredicate] = []
        if let subject = filter.subject {
            predicates.append(NSPredicate(format: "subject == %@", subject))
        }
        if let chapter = filter.chapter {
            predicates.append(NSPredicate(format: "chapter == %@", chapter))
        }
        if !filter.tags.isEmpty {
            predicates.append(NSPredicate(format: "ANY tags IN %@", filter.tags))
        }
        predicates.append(NSPredicate(format: "difficulty >= %d AND difficulty <= %d", filter.difficultyRange.lowerBound, filter.difficultyRange.upperBound))
        if let keyword = filter.searchKeyword, !keyword.isEmpty {
            predicates.append(NSPredicate(format: "questionText CONTAINS[cd] %@ OR answerText CONTAINS[cd] %@", keyword, keyword))
        }
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "updatedAt", ascending: false)]
        return try context.fetch(request)
    }

    func upsert(using dto: ProblemDTO, now: Date) throws {
        let request = Problem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", dto.id as CVarArg)
        let problem = try context.fetch(request).first ?? Problem(context: context)
        problem.id = dto.id
        problem.subject = dto.subject
        problem.chapter = dto.chapter
        problem.sourceTitle = dto.sourceTitle
        problem.sourceMeta = dto.sourceMeta
        problem.questionText = dto.questionText
        problem.answerText = dto.answerText
        problem.imagePaths = dto.imagePaths
        problem.answerImages = dto.answerImages
        problem.tags = dto.tags
        problem.latexSnippets = dto.latex
        problem.difficulty = Int16(dto.difficulty)
        problem.hasFormula = dto.hasFormula
        if problem.createdAt == .distantPast {
            problem.createdAt = now
        }
        problem.updatedAt = now
        if problem.srsInterval == 0 {
            problem.srsInterval = 1
            problem.srsEase = 2.5
            problem.srsDueDate = now
            problem.srsLapses = 0
            problem.streak = 0
        }
        try context.save()
    }

    func updateSRS(id: UUID, state: SrsState) throws {
        let request = Problem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let problem = try context.fetch(request).first else { throw ProblemRepositoryError.notFound }
        problem.srsEase = state.ease
        problem.srsInterval = Int32(state.interval)
        problem.srsDueDate = state.dueDate
        problem.srsLapses = Int16(state.lapses)
        problem.updatedAt = Date()
        try context.save()
    }

    func logReview(problemId: UUID, result: ReviewResult, duration: TimeInterval, note: String?) {
        let request = Problem.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", problemId as CVarArg)
        guard let problem = try? context.fetch(request).first else { return }
        let log = ReviewLog(context: context)
        log.id = UUID()
        log.timestamp = Date()
        log.duration = duration
        log.note = note
        log.result = result == .correct ? .correct : .wrong
        log.problem = problem
        if result == .correct {
            problem.streak += 1
        } else {
            problem.streak = 0
        }
        try? context.save()
    }
}
