import Foundation
import CoreData

extension Problem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Problem> {
        NSFetchRequest<Problem>(entityName: "Problem")
    }

    @NSManaged public var id: UUID
    @NSManaged public var subject: String
    @NSManaged public var chapter: String?
    @NSManaged public var sourceTitle: String?
    @NSManaged public var sourceMeta: String?
    @NSManaged public var questionText: String?
    @NSManaged public var answerText: String?
    @NSManaged public var imagePaths: [String]
    @NSManaged public var answerImages: [String]
    @NSManaged public var tags: [String]
    @NSManaged public var latexSnippets: [String]
    @NSManaged public var difficulty: Int16
    @NSManaged public var hasFormula: Bool
    @NSManaged public var imagePHash: Data?
    @NSManaged public var textMinHash: Data?
    @NSManaged public var createdAt: Date
    @NSManaged public var updatedAt: Date
    @NSManaged public var srsEase: Double
    @NSManaged public var srsInterval: Int32
    @NSManaged public var srsDueDate: Date
    @NSManaged public var srsLapses: Int16
    @NSManaged public var streak: Int16
    @NSManaged public var reviewLogs: Set<ReviewLog>
    @NSManaged public var deckCards: Set<DeckCard>
}

extension Problem : Identifiable {}
