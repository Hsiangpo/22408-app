import Foundation
import CoreData

enum DeckCardType: Int16 {
    case basic = 0
    case cloze = 1
}

extension DeckCard {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DeckCard> {
        NSFetchRequest<DeckCard>(entityName: "DeckCard")
    }

    @NSManaged public var id: UUID
    @NSManaged public var typeRaw: Int16
    @NSManaged public var front: String?
    @NSManaged public var back: String?
    @NSManaged public var clozeJSON: Data?
    @NSManaged public var srsEase: Double
    @NSManaged public var srsInterval: Int32
    @NSManaged public var srsDueDate: Date
    @NSManaged public var srsLapses: Int16
    @NSManaged public var streak: Int16
    @NSManaged public var problem: Problem?

    var type: DeckCardType {
        get { DeckCardType(rawValue: typeRaw) ?? .basic }
        set { typeRaw = newValue.rawValue }
    }
}

extension DeckCard: Identifiable {}
