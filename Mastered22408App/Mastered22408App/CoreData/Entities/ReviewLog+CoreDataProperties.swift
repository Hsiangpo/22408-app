import Foundation
import CoreData

enum ReviewResultValue: Int16 {
    case wrong = 0
    case correct = 1
}

extension ReviewLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewLog> {
        NSFetchRequest<ReviewLog>(entityName: "ReviewLog")
    }

    @NSManaged public var id: UUID
    @NSManaged public var timestamp: Date
    @NSManaged public var resultRaw: Int16
    @NSManaged public var duration: Double
    @NSManaged public var note: String?
    @NSManaged public var problem: Problem?

    var result: ReviewResultValue {
        get { ReviewResultValue(rawValue: resultRaw) ?? .wrong }
        set { resultRaw = newValue.rawValue }
    }
}

extension ReviewLog: Identifiable {}
