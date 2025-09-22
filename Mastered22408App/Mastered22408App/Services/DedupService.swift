import Foundation
import UIKit

final class DedupService {
    func isTextDuplicate(lhs: [UInt32], rhs: [UInt32], threshold: Double = 0.85) -> Bool {
        guard lhs.count == rhs.count, !lhs.isEmpty else { return false }
        let overlap = zip(lhs, rhs).filter {  ==  }.count
        return Double(overlap) / Double(lhs.count) >= threshold
    }

    func computeMinHash(for text: String, shards: Int = 32) -> [UInt32] {
        guard !text.isEmpty else { return [] }
        let words = text.split(separator: " ")
        return (0..<shards).map { shard in
            var best: UInt32 = UInt32.max
            for (index, word) in words.enumerated() {
                var hasher = Hasher()
                hasher.combine(shard)
                hasher.combine(index)
                hasher.combine(word)
                let hash = UInt32(bitPattern: Int32(hasher.finalize()))
                best = min(best, hash)
            }
            return best
        }
    }

    func computePHash(for image: UIImage) -> Data? {
        // 占位：生产环境可接入OpenCV或自实现DCT
        return nil
    }
}
