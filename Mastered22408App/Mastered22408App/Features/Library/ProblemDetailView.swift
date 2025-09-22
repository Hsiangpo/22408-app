import SwiftUI

struct ProblemDetailView: View {
    let problem: Problem

    var body: some View {
        List {
            Section("题目") {
                Text(problem.questionText ?? "图像题")
                ForEach(problem.imagePaths, id: \.self) { path in
                    if let url = URL(string: path) {
                        AsyncImage(url: url) { image in image.resizable() } placeholder: { ProgressView() }
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            Section("答案") {
                Text(problem.answerText ?? "尚未填写")
                ForEach(problem.answerImages, id: \.self) { path in
                    if let url = URL(string: path) {
                        AsyncImage(url: url) { image in image.resizable() } placeholder: { ProgressView() }
                            .frame(height: 160)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
            }
            if !problem.tags.isEmpty {
                Section("标签") {
                    Text(problem.tags.joined(separator: " · "))
                }
            }
            Section("统计") {
                Text("间隔：\(problem.srsInterval) 天")
                Text("Ease：\(String(format: "%.2f", problem.srsEase))")
                Text("Streak：\(problem.streak)")
            }
            Section("历史记录") {
                if problem.reviewLogs.isEmpty {
                    Text("暂无记录")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(problem.reviewLogs.sorted { .timestamp > .timestamp }) { log in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(log.timestamp, style: .date)
                            Text(log.result == .correct ? "做对" : "做错")
                                .foregroundStyle(log.result == .correct ? .green : .red)
                            if let note = log.note { Text(note).font(.footnote) }
                        }
                    }
                }
            }
        }
        .navigationTitle(problem.subject)
    }
}
