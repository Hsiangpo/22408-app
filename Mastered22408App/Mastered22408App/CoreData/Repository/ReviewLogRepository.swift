import Foundation
import CoreData

protocol ReviewLogRepository {
    func recentLogs(limit: Int) throws -> [ReviewLog]
}

final class DefaultReviewLogRepository: ReviewLogRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func recentLogs(limit: Int) throws -> [ReviewLog] {
        let request = ReviewLog.fetchRequest()
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        return try context.fetch(request)
    }
}
