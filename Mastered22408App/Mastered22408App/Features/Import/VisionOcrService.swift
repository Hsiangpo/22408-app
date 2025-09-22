import Foundation
import UIKit
#if canImport(Vision)
import Vision
#endif
#if canImport(VisionKit)
import VisionKit
#endif

final class VisionOcrService: OcrService {
    func recognizeText(from images: [UIImage]) async throws -> [OcrResult] {
        #if canImport(Vision)
        return try await withThrowingTaskGroup(of: OcrResult.self) { group in
            for image in images {
                group.addTask {
                    guard let cgImage = image.cgImage else { throw OcrServiceError.invalidImage }
                    let request = VNRecognizeTextRequest()
                    request.recognitionLevel = .accurate
                    request.usesLanguageCorrection = true
                    request.recognitionLanguages = ["zh-Hans", "en-US"]
                    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    try handler.perform([request])
                    let recognized = request.results?.compactMap { .topCandidates(1).first?.string }.joined(separator: "\n") ?? ""
                    let hasFormula = recognized.contains("\\") || recognized.contains("∫")
                    return OcrResult(image: image, recognizedText: recognized, hasFormula: hasFormula)
                }
            }
            var results: [OcrResult] = []
            for try await result in group { results.append(result) }
            return results
        }
        #else
        return []
        #endif
    }

    #if canImport(VisionKit)
    func makeScanner() throws -> DataScannerViewController {
        guard DataScannerViewController.isSupported else { throw OcrServiceError.notSupported }
        return DataScannerViewController(
            recognizedDataTypes: [.text(), .barcode()],
            qualityLevel: .balanced,
            isMultipleItemScanningEnabled: true,
            isHighFrameRateTrackingEnabled: true
        )
    }
    #endif
}
