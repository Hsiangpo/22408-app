import Foundation

final class SampleDataLoader {
    static let shared = SampleDataLoader()
    private let seededKey = "io.mastered22408.seeded"
    let subjects = ["数学", "英语", "政治", "数据结构"]

    func bootstrapIfNeeded(using problemRepository: ProblemRepository, reviewRepository: ReviewLogRepository) {
        let defaults = UserDefaults.standard
        guard !defaults.bool(forKey: seededKey) else { return }
        let now = Date()
        let samples: [ProblemDTO] = [
            ProblemDTO(
                id: UUID(),
                subject: "数学",
                chapter: "定积分",
                sourceTitle: "张宇 18讲",
                sourceMeta: "例题2",
                questionText: "计算 ∫₀¹ x e^{x²} dx",
                answerText: "换元 u = x²，可得结果 (e-1)/2",
                imagePaths: [],
                answerImages: [],
                tags: ["换元法"],
                latex: ["\\int_0^1 x e^{x^2} dx"],
                difficulty: 2,
                hasFormula: true
            ),
            ProblemDTO(
                id: UUID(),
                subject: "英语",
                chapter: "阅读理解",
                sourceTitle: "黄皮书",
                sourceMeta: "2024 SectionA",
                questionText: "段落主旨选择题为什么选B?",
                answerText: "关键词在第三段，主题句对比得出",
                imagePaths: [],
                answerImages: [],
                tags: ["主旨题"],
                latex: [],
                difficulty: 3,
                hasFormula: false
            )
        ]
        samples.forEach { dto in try? problemRepository.upsert(using: dto, now: now) }
        defaults.set(true, forKey: seededKey)
    }
}
