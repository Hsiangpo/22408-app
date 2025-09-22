import SwiftUI

@MainActor
final class ImportCoordinator: ObservableObject {
    struct ImportCandidate: Identifiable {
        let id = UUID()
        let image: UIImage
        let ocrText: String
        let hasFormula: Bool
    }

    @Published var candidates: [ImportCandidate] = []
    @Published var isProcessing: Bool = false
    private let ocr: OcrService

    init(ocr: OcrService) {
        self.ocr = ocr
    }

    func process(_ images: [UIImage]) async {
        guard !images.isEmpty else { return }
        isProcessing = true
        defer { isProcessing = false }
        do {
            let results = try await ocr.recognizeText(from: images)
            candidates = results.map { ImportCandidate(image: .image, ocrText: .recognizedText, hasFormula: .hasFormula) }
        } catch {
            candidates = images.map { ImportCandidate(image: , ocrText: "", hasFormula: false) }
        }
    }
}
