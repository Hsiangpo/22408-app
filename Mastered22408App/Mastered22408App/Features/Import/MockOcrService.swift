import UIKit

final class MockOcrService: OcrService {
    func recognizeText(from images: [UIImage]) async throws -> [OcrResult] {
        images.enumerated().map { index, image in
            OcrResult(image: image, recognizedText: "示例文本 #\(index)", hasFormula: false)
        }
    }
    #if canImport(VisionKit)
    func makeScanner() throws -> DataScannerViewController {
        throw OcrServiceError.notSupported
    }
    #endif
}
