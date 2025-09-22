import Foundation
import Combine

final class AppEnvironment: ObservableObject {
    let coreDataStack: CoreDataStack
    let problemRepository: ProblemRepository
    let reviewLogRepository: ReviewLogRepository
    let ocrService: OcrService
    let srsScheduler: SrsScheduler
    let notificationScheduler: NotificationScheduler
    let dedupService: DedupService

    @Published var isMathpixEnabled: Bool = false
    @Published var isLLMEnabled: Bool = false

    init() {
        coreDataStack = CoreDataStack(modelName: "Mastered22408App")
        let context = coreDataStack.viewContext
        problemRepository = DefaultProblemRepository(context: context)
        reviewLogRepository = DefaultReviewLogRepository(context: context)
        ocrService = VisionOcrService()
        srsScheduler = SrsScheduler()
        notificationScheduler = NotificationScheduler()
        dedupService = DedupService()
        SampleDataLoader.shared.bootstrapIfNeeded(using: problemRepository, reviewRepository: reviewLogRepository)
    }
}
