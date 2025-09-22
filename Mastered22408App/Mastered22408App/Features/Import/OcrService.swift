import Foundation
import UIKit
#if canImport(Vision)
import Vision
#endif
#if canImport(VisionKit)
import VisionKit
#endif

struct OcrResult {
    let image: UIImage
    let recognizedText: String
    let hasFormula: Bool
}

protocol OcrService {
    func recognizeText(from images: [UIImage]) async throws -> [OcrResult]
    #if canImport(VisionKit)
    func makeScanner() throws -> DataScannerViewController
    #endif
}

enum OcrServiceError: Error {
    case notSupported
    case invalidImage
}
